import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class ReviewCard extends StatelessWidget {
  final int starCount;
  final String date;
  final String title;
  final String reviewerName;
  final String reviewText;
  final int helpfulCount;

  const ReviewCard({
    super.key,
    required this.starCount,
    required this.date,
    required this.title,
    required this.reviewerName,
    required this.reviewText,
    required this.helpfulCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < starCount
                        ? AppColors.yellowColorFC
                        : AppColors.greyColorColor80,
                    size: 18.sp,
                  );
                }),
              ),
              // Date
              Text(
                date,
                style: TextStyles.font10WhiteColorW600.copyWith(
                  color: AppColors.greyColorColor80,
                ),
              ),
            ],
          ),
          verticalSpace(12),

          Text(
            title,
            style: TextStyles.font12InterWhiteW400.copyWith(
              color: AppColors.whiteColor,
              fontSize: 13.sp,

              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpace(6),

          // Reviewer Name
          Text(
            reviewerName,
            style: TextStyles.font12InterWhiteW400.copyWith(
              color: AppColors.greyColorColor80,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          verticalSpace(12),
          Text(
            reviewText,
            style: TextStyles.font12whiteColorColorW400.copyWith(
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 16.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_outlined,
                    color: Colors.white.withOpacity(0.6),
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Helpful",
                    style: TextStyles.font10WhiteColorW600.copyWith(
                      color: AppColors.greyColorColor80,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "($helpfulCount)",
                    style: TextStyles.font10WhiteColorW600.copyWith(
                      color: AppColors.greyColorColor80,
                    ),
                  ),
                ],
              ),
              // Report button
              Text(
                "Report",
                style: TextStyles.font10WhiteColorW600.copyWith(
                  color: AppColors.greyColorColor80,
                ),
              ),
            ],
          ),
          verticalSpace(20),
          Center(
            child: Container(
              width: 170.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Center(
                child: Text(
                  "Load More Reviews",
                  style: TextStyles.font12PrimaryColorW700.copyWith(
                    fontFamily: "Inter",
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
