import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/ui/widgets/push_leaderboard_row_info_widget.dart';

class PuhsUpsLeaderboardScreen extends StatelessWidget {
  const PuhsUpsLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

                    const Divider(color: Colors.white, thickness: 1),

                    ListView.builder(
                      itemCount: 6,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemBuilder: (context, index) {
                        return PushupLeaderBoardRowInf(
                          rank: index + 1,
                          name: "User $index",
                          image:
                              "https://randomuser.me/api/portraits/men/$index.jpg",
                          reps: "${index * 100 + 1000}",
                          diff: "+${index * 10}",
                          highlight: index == 3,
                          medalColor: AppColors.orangeColorEA,
                        );
                      },
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
  }
}
