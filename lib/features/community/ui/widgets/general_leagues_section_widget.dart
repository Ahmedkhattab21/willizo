import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/ui/widgets/league_list_item_widget.dart';

class GeneralLeaguesSectionWidget extends StatelessWidget {
  const GeneralLeaguesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "General Leagues",
          style: TextStyles.font18WhiteColor700.copyWith(fontSize: 20.sp),
        ),
        verticalSpace(16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.greenColorEF, AppColors.greenColorFD],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.all(1.0), // Border width
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.blackColor171C, // Inner background
              borderRadius: BorderRadius.circular(11.r),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: AppColors.blueColorFB,
                        size: 24.sp,
                      ),
                      horizontalSpace(8),
                      Text("League", style: TextStyles.font16WhiteColorW600),
                      const Spacer(),
                      Text(
                        "Current Rank",
                        style: TextStyles.font12greyColorColor79W400.copyWith(
                          color: AppColors.whiteColorD9,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppColors.whiteColorD9,
                  thickness: 0.5,
                  height: 1,
                ),

                const LeagueListItemWidget(
                  title: "Push up",
                  subscribersCount: "521,424 subscribers",
                  rank:
                      100545, // Formatting as string handled outside or by custom logic if needed, but going with int for now per design
                  isRankUp: true,
                ),
                const LeagueListItemWidget(
                  title: "David Kim",
                  subscribersCount: "15 subscribers",
                  rank: 8,
                  isRankUp: false,
                ),
                const LeagueListItemWidget(
                  title: "Lisa Rodriguez",
                  subscribersCount: "30 subscribers",
                  rank: 20,
                  isRankUp: true,
                ),
                const LeagueListItemWidget(
                  title: "James Park",
                  subscribersCount: "10 subscribers",
                  rank: 3,
                  isRankUp: false,
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
