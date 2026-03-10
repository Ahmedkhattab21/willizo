import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/data/models/leaderboard_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';

class TopFriendsBoardCard extends StatelessWidget {
  const TopFriendsBoardCard({super.key, this.onViewAllFriendsPressed});

  final VoidCallback? onViewAllFriendsPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        final cubit = CommunityCubit.get(context);
        final isLoading = state is LeaderboardLoadingState;
        final friends = state is LeaderboardLoadedState
            ? state.leaderboardFriends
            : cubit.leaderboardFriends;
        final displayList = friends.take(4).toList();

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 2, color: Colors.transparent),
            gradient: LinearGradient(
              colors: [AppColors.greenColorEF, AppColors.greenColorFD],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF181C00),
              borderRadius: BorderRadius.circular(14),
            ),
            child: isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 24.h,
                            width: 24.w,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.blueColorFB,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              ImageAsset.groupIcon,
                              height: 16.h,
                              width: 16.w,
                            ),
                          ),
                          horizontalSpace(8),
                          Text(
                            "Top Friends",
                            style: TextStyles.font16White2ColorW600,
                          ),
                        ],
                      ),
                      Text(
                        "Total points",
                        style: TextStyles.font12InterW400.copyWith(
                          color: AppColors.greyColorD1,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white, thickness: 1),
                if (displayList.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: Text(
                        "No friends yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  )
                else
                  ...displayList.map((entry) => FrindInfo(entry: entry)),
                verticalSpace(6),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: GestureDetector(
                    onTap: onViewAllFriendsPressed,
                    child: const Text(
                      "View All Friends",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FrindInfo extends StatelessWidget {
  final LeaderboardEntry entry;

  const FrindInfo({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final scoreFormatted = NumberFormat('#,###').format(entry.score);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            horizontalSpace(12),
            ClipOval(
              child: Container(
                width: 36,
                height: 36,
                color: AppColors.greyColorD1,
                child: const Icon(Icons.person, color: Colors.white, size: 24),
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Text(
                entry.user.fullName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  scoreFormatted,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "points",
                  style: TextStyles.font12InterWhiteW400.copyWith(
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
