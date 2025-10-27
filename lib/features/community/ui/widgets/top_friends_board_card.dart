import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/ui/community_screen.dart';

class TopFriendsBoardCard extends StatelessWidget {
  const TopFriendsBoardCard({super.key});

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
                        "Push-ups Leaderboard",
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
            FrindInfo(),
            FrindInfo(),
            FrindInfo(),
            FrindInfo(),
            verticalSpace(6),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: GestureDetector(
                onTap: () {
                  final parentState = context
                      .findAncestorStateOfType<CommunityScreenState>();
                  parentState!.setState(() {
                    parentState.showTopFriends = true;
                  });
                },

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
  }
}

class FrindInfo extends StatelessWidget {
  const FrindInfo({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Image.network(
                "https://randomuser.me/api/portraits/men/44.jpg",
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
                    "Alex Johnson",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "12 excerises complete",
                    style: TextStyles.font12InterWhiteW400,
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "8,543",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text("points", style: TextStyles.font12InterWhiteW400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
