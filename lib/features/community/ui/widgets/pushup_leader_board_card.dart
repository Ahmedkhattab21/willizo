import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class PushupLeaderBoardCard extends StatelessWidget {
  const PushupLeaderBoardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(16),
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
            // verticalSpace(5),
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

            _buildUserRow(
              rank: 1,
              name: "Alex Johnson",
              image: "https://randomuser.me/api/portraits/men/75.jpg",
              reps: "2,450",
              diff: "+125",
              highlight: false,
              medalColor: AppColors.orangeColorEA,
            ),
            _buildUserRow(
              rank: 2,
              name: "Sarah Chen",
              image: "https://randomuser.me/api/portraits/women/65.jpg",
              reps: "2,180",
              diff: "+98",
              highlight: false,
              medalColor: AppColors.greyColorCA,
            ),
            _buildUserRow(
              rank: 3,
              name: "Mike Torres",
              image: "https://randomuser.me/api/portraits/men/44.jpg",
              reps: "1,920",
              diff: "+87",
              highlight: false,
              medalColor: AppColors.redColorF9,
            ),

            verticalSpace(6),

            /// --- Current user section ---
            _buildUserRow(
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
              child: const Text(
                "View Full Leaderboard",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow({
    required int rank,
    required String name,
    required String image,
    required String reps,
    required String diff,
    bool highlight = false,
    Color? medalColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: highlight ? 8.w : 0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12.w),
        decoration: BoxDecoration(
          color: highlight ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 34.w,
              width: 34.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: medalColor ?? Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ),

            horizontalSpace(12),

            /// Profile image
            ClipOval(
              child: Image.network(
                image,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),

            horizontalSpace(12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: highlight ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "$reps reps",
                    style: TextStyle(
                      color: highlight
                          ? AppColors.greyColorColor80
                          : Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  reps,
                  style: TextStyle(
                    color: highlight ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  diff,
                  style: const TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: 12,
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
