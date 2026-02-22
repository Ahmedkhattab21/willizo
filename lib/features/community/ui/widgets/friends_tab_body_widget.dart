import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/community/ui/widgets/all_friends_tab_body_widget.dart';
import 'package:willizo/features/community/ui/widgets/custom_search_bar_widget.dart';
import 'package:willizo/features/community/ui/widgets/friends_tab_bar_widget.dart';
import 'package:willizo/features/community/ui/widgets/profile_state_item_widget.dart';
import 'package:willizo/features/community/ui/widgets/suggested_friends_tab_body_widget.dart';

class FriendsTabBodyWidget extends StatefulWidget {
  const FriendsTabBodyWidget({super.key});

  @override
  State<FriendsTabBodyWidget> createState() => _FriendsTabBodyWidgetState();
}

class _FriendsTabBodyWidgetState extends State<FriendsTabBodyWidget> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _currentTabIndex == 0
          ? FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {},
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
            CustomSearchBarWidget(),
            verticalSpace(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileStatItem(
                  number: "47",
                  label: "Friends",
                  numberColor: AppColors.whiteColor,
                ),
                ProfileStatItem(
                  number: "12",
                  label: "Workout Partners",
                  numberColor: AppColors.blueColorFB,
                ),
                ProfileStatItem(
                  number: "8",
                  label: "Active Today",
                  numberColor: AppColors.primaryColor,
                ),
              ],
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
                : const SuggestedFriendsTabBodyWidget(),
          ],
        ),
      ),
    );
  }
}
