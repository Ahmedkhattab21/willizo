import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/features/community/ui/widgets/leader_board_grid_widget.dart';
import 'package:willizo/features/community/ui/widgets/pushup_leader_board_card.dart';
import 'package:willizo/features/community/ui/widgets/top_friends_board_card.dart';
import 'package:willizo/features/community/ui/widgets/weekly_challenge_card_widget.dart';

class LeaderboardBody extends StatelessWidget {
  final VoidCallback? onViewAllPressed;

  const LeaderboardBody({super.key, this.onViewAllPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [AppColors.greenColorEF, AppColors.greenColorFD],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Rank', style: TextStyles.font18InterW600),
                        Text(
                          "Keep pushing forward!",
                          style: TextStyles.font14InterW600,
                        ),
                        verticalSpace(10),
                        Text("#12", style: TextStyles.font24InterW700),
                        Text(
                          "Overall Ranking",
                          style: TextStyles.font14InterW400,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 48.w,
                          width: 48.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              ImageAsset.worldCrownIcon,
                              height: 15.w,
                              width: 15.w,
                            ),
                          ),
                        ),
                        verticalSpace(6),
                        Text(
                          "2,847",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24.sp,
                          ),
                        ),
                        Text("Total Points", style: TextStyles.font14InterW400),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(15),
            Row(
              children: [
                Text(
                  "Exercise Categories",
                  style: TextStyles.font18WhiteInterW600,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onViewAllPressed,
                  child: Text(
                    "View all",
                    style: TextStyles.font12GreenColorW500,
                  ),
                ),
              ],
            ),
            verticalSpace(10),
            LeaderboardGrid(),
            verticalSpace(15),
            PushupLeaderBoardCard(),
            verticalSpace(15),
            TopFriendsBoardCard(),
            verticalSpace(20),
            WeeklyChallengeCard(),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
