import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/top_follower_card_widget.dart';

class FriendsTopFollowersSection extends StatefulWidget {
  const FriendsTopFollowersSection({super.key});

  @override
  State<FriendsTopFollowersSection> createState() =>
      _FriendsTopFollowersSectionState();
}

class _FriendsTopFollowersSectionState
    extends State<FriendsTopFollowersSection> {
  static String _formatFollowers(int count) {
    if (count >= 1000) {
      final k = count / 1000;
      return k == k.truncateToDouble()
          ? '${k.toInt()}K followers'
          : '${k.toStringAsFixed(1)}K followers';
    }
    return '$count followers';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CommunityCubit.get(context).getTopFollowers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      buildWhen: (previous, current) =>
          current is TopFollowersLoadingState ||
          current is TopFollowersLoadedState ||
          current is TopFollowersErrorState,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                  ],
                ),
                horizontalSpace(8),
                Text(
                  "Top Followers",
                  style: TextStyles.font18InterW400.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  "See All",
                  style: TextStyles.font14primaryColorW600.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            verticalSpace(8),
            Text(
              "Popular people you might know",
              style: TextStyles.font14greyColorColor79W400.copyWith(
                fontSize: 12.sp,
              ),
            ),
            verticalSpace(16),
            Divider(color: AppColors.greyColor3d, thickness: 1, height: 1),
            verticalSpace(16),
            _buildBody(state),
            verticalSpace(32),
          ],
        );
      },
    );
  }

  Widget _buildBody(CommunityState state) {
    if (state is TopFollowersLoadingState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: SizedBox(
            width: 28.w,
            height: 28.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      );
    }

    final cubit = CommunityCubit.get(context);
    final hasLoaded =
        state is TopFollowersLoadedState || cubit.hasFetchedTopFollowers;

    if (hasLoaded) {
      final list = cubit.topFollowers;
      if (list.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Center(
            child: Text(
              "No top followers yet",
              style: TextStyles.font14greyColorColor79W400.copyWith(
                fontSize: 13.sp,
              ),
            ),
          ),
        );
      }
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.75,
        children: list
            .map(
              (item) => TopFollowerCardWidget(
                name: item.fullName,
                followersCount: _formatFollowers(item.followersCount),
                isFollowing: item.isFollowing,
                onFollow: () =>
                    CommunityCubit.get(context).toggleFollowSuggestedUser(
                      userId: item.id,
                      isFollowing: item.isFollowing,
                    ),
              ),
            )
            .toList(),
      );
    }

    if (state is TopFollowersErrorState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Text(
            "No top followers yet",
            style: TextStyles.font14greyColorColor79W400.copyWith(
              fontSize: 13.sp,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
