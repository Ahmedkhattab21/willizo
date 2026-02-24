import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/data/models/leaderboard_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/push_leaderboard_row_info_widget.dart';

class PushupLeaderBoardCard extends StatelessWidget {
  const PushupLeaderBoardCard({super.key, this.onViewFullLeaderboardPressed});

  /// Called with the exercise name (e.g. "Bench Press") when "View Full Leaderboard" is pressed.
  final void Function(String exerciseName)? onViewFullLeaderboardPressed;

  static Color _medalColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.orangeColorEA;
      case 2:
        return AppColors.greyColorCA;
      case 3:
        return AppColors.redColorF9;
      default:
        return AppColors.blueColorF9;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        final isLoading = state is LeaderboardLoadingState;
        final friends = state is LeaderboardLoadedState
            ? state.leaderboardFriends
            : <LeaderboardEntry>[];
        final myEntry = state is LeaderboardLoadedState ? state.myEntry : null;
        final firstCardExercise =
            state is LeaderboardLoadedState ? state.firstCardExercise : null;
        final topThree = friends.take(3).toList();
        final titleLoaded = firstCardExercise?.name;

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
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                              color: AppColors.greenColorAB,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              ImageAsset.coloredDoumble,
                              height: 16.h,
                              width: 16.w,
                              colorFilter: const ColorFilter.mode(
                                AppColors.whiteColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          horizontalSpace(8),
                          titleLoaded != null
                              ? Text(
                                  titleLoaded,
                                  style: TextStyles.font16White2ColorW600,
                                )
                              : SizedBox(
                                  height: 24.w,
                                  width: 24.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                        ],
                      ),
                      Text(
                        "This Week",
                        style: TextStyles.font12InterW400.copyWith(
                          color: AppColors.greyColorD1,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white, thickness: 1),
                if (topThree.isEmpty && myEntry == null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: SizedBox(
                      height: 24.w,
                      width: 24.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                else ...[
                  ...topThree.map((entry) {
                    final scoreStr = NumberFormat('#,###').format(entry.score);
                    final rankDiff = entry.previousRank - entry.rank;
                    final diffStr = rankDiff > 0 ? '+$rankDiff' : '$rankDiff';
                    return PushupLeaderBoardRowInf(
                      rank: entry.rank,
                      name: entry.user.fullName,
                      reps: scoreStr,
                      diff: diffStr,
                      highlight: false,
                      medalColor: _medalColor(entry.rank),
                      unitLabel: 'reps',
                    );
                  }),
                  if (myEntry != null) ...[
                    verticalSpace(6),
                    PushupLeaderBoardRowInf(
                      rank: myEntry.rank,
                      name: "You",
                      reps: NumberFormat('#,###').format(myEntry.score),
                      diff: myEntry.previousRank > 0
                          ? (myEntry.previousRank - myEntry.rank > 0
                              ? '+${myEntry.previousRank - myEntry.rank}'
                              : '${myEntry.previousRank - myEntry.rank}')
                          : '--',
                      medalColor: AppColors.blueColorF9,
                      highlight: true,
                      unitLabel: 'reps',
                    ),
                  ],
                ],
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: GestureDetector(
                    onTap: () => onViewFullLeaderboardPressed?.call(
                      titleLoaded ?? 'Leaderboard',
                    ),
                    child: const Text(
                      "View Full Leaderboard",
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
