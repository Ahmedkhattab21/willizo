import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/community/ui/widgets/add_friend_dialog.dart';
import 'package:willizo/features/community/ui/widgets/all_friends_tab_body_widget.dart';
import 'package:willizo/features/community/ui/widgets/custom_search_bar_widget.dart';
import 'package:willizo/features/community/ui/widgets/friends_tab_bar_widget.dart';
import 'package:willizo/features/community/ui/widgets/profile_state_item_widget.dart';
import 'package:willizo/features/community/ui/widgets/friend_requests_tab_body_widget.dart';
import 'package:willizo/features/community/ui/widgets/suggested_friends_tab_body_widget.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';

class FriendsTabBodyWidget extends StatefulWidget {
  const FriendsTabBodyWidget({super.key});

  @override
  State<FriendsTabBodyWidget> createState() => _FriendsTabBodyWidgetState();
}

class _FriendsTabBodyWidgetState extends State<FriendsTabBodyWidget> {
  int _currentTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CommunityCubit>().getFriendsStats();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      context.read<CommunityCubit>().getFriends(
        refresh: true,
        search: value.trim(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _currentTabIndex == 0 || _currentTabIndex == 2
          ? FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () => showAddFriendDialog(context),
              backgroundColor: AppColors.primaryColor,
              child: const Icon(
                Icons.person_add_alt_1,
                color: AppColors.blackColor,
              ),
            )
          : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            CustomSearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),
            verticalSpace(16),
            BlocBuilder<CommunityCubit, CommunityState>(
              buildWhen: (_, state) =>
                  state is FriendsStatsLoadingState ||
                  state is FriendsStatsLoadedState ||
                  state is FriendsStatsErrorState,
              builder: (context, state) {
                final stats = CommunityCubit.get(context).friendsStats;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProfileStatItem(
                      number: stats?.friendsCount.toString() ?? "--",
                      label: "Friends",
                      numberColor: AppColors.whiteColor,
                    ),
                    ProfileStatItem(
                      number: stats?.workoutPartnersCount.toString() ?? "--",
                      label: "Workout Partners",
                      numberColor: AppColors.blueColorFB,
                    ),
                    ProfileStatItem(
                      number: stats?.activeTodayCount.toString() ?? "--",
                      label: "Active Today",
                      numberColor: AppColors.primaryColor,
                    ),
                  ],
                );
              },
            ),
            verticalSpace(24),
            FriendsTabBarWidget(
              onTabChanged: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
            ),
            verticalSpace(24),
            _currentTabIndex == 0
                ? const AllFriendsTabBodyWidget()
                : _currentTabIndex == 1
                ? const SuggestedFriendsTabBodyWidget()
                : const FriendRequestsTabBodyWidget(),
          ],
        ),
      ),
    );
  }
}
