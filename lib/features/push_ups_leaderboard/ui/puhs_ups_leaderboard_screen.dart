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
import 'package:willizo/features/community/ui/widgets/push_leaderboard_row_info_widget.dart';

class PuhsUpsLeaderboardScreen extends StatelessWidget {
  const PuhsUpsLeaderboardScreen({super.key});

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
        final titleLoaded = firstCardExercise?.name;

        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: Column(
              children: [
                Container(
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
                    child: Column(
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
                                "Total points",
                                style: TextStyles.font12InterW400.copyWith(
                                  color: AppColors.greyColorD1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: Colors.white, thickness: 1),
                        if (friends.isEmpty && myEntry == null)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: Text(
                              "No leaderboard data yet",
                              style: TextStyles.font12InterW400.copyWith(
                                color: AppColors.greyColorD1,
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Column(
                              children: [
                                ...friends.map((entry) {
                                  final scoreStr =
                                      NumberFormat('#,###').format(entry.score);
                                  final rankDiff =
                                      entry.previousRank - entry.rank;
                                  final diffStr = rankDiff > 0
                                      ? '+$rankDiff'
                                      : '$rankDiff';
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
                                    reps: NumberFormat('#,###')
                                        .format(myEntry.score),
                                    diff: myEntry.previousRank > 0
                                        ? (myEntry.previousRank -
                                                    myEntry.rank >
                                                0
                                            ? '+${myEntry.previousRank - myEntry.rank}'
                                            : '${myEntry.previousRank - myEntry.rank}')
                                        : '--',
                                    medalColor: AppColors.blueColorF9,
                                    highlight: true,
                                    unitLabel: 'reps',
                                  ),
                                ],
                              ],
                            ),
                          ),
                        verticalSpace(10),
                      ],
                    ),
                  ),
                ),
                verticalSpace(50),
              ],
            ),
          ),
        );
      },
    );
  }
}
