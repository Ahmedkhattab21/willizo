import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/ui/community_screen.dart';
import 'package:willizo/features/community/ui/widgets/push_leaderboard_row_info_widget.dart';

class PushupLeaderBoardCard extends StatelessWidget {
  const PushupLeaderBoardCard({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
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
                          color: AppColors.whiteColor,
                        ),
                      ),
                      horizontalSpace(8),
                      Text(
                        "Push-ups Leaderboard",
                        style: TextStyles.font16White2ColorW600,
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

            PushupLeaderBoardRowInf(
              rank: 1,
              name: "Alex Johnson",
              image: "https://randomuser.me/api/portraits/men/75.jpg",
              reps: "2,450",
              diff: "+125",
              highlight: false,
              medalColor: AppColors.orangeColorEA,
            ),
            PushupLeaderBoardRowInf(
              rank: 2,
              name: "Sarah Chen",
              image: "https://randomuser.me/api/portraits/women/65.jpg",
              reps: "2,180",
              diff: "+98",
              highlight: false,
              medalColor: AppColors.greyColorCA,
            ),
            PushupLeaderBoardRowInf(
              rank: 3,
              name: "Mike Torres",
              image: "https://randomuser.me/api/portraits/men/44.jpg",
              reps: "1,920",
              diff: "+87",
              highlight: false,
              medalColor: AppColors.redColorF9,
            ),

            verticalSpace(6),

            PushupLeaderBoardRowInf(
              rank: 7,
              name: "You",
              image: "https://randomuser.me/api/portraits/men/46.jpg",
              reps: "1,340",
              diff: "+45",
              medalColor: AppColors.blueColorF9,
              highlight: true,
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: GestureDetector(
                onTap: () {
                  final parentState = context
                      .findAncestorStateOfType<CommunityScreenState>();
                  parentState!.setState(() {
                    parentState.showPushupsLeaderboard = true;
                  });
                },
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
  }
}
