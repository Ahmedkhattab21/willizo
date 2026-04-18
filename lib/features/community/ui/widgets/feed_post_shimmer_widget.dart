import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class FeedPostShimmerWidget extends StatelessWidget {
  const FeedPostShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor3d,
      highlightColor: AppColors.greyColor75.withValues(alpha: 0.5),
      period: const Duration(milliseconds: 1200),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header shimmer
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: const BoxDecoration(
                          color: AppColors.greyColor3d,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              color: AppColors.greyColor3d,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            height: 10.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: AppColors.greyColor3d,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Content text shimmer
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    height: 14.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor3d,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Reactions shimmer
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Container(
                        height: 20.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: AppColors.greyColor3d,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Container(
                        height: 20.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: AppColors.greyColor3d,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 20.h,
                        width: 22.w,
                        decoration: BoxDecoration(
                          color: AppColors.greyColor3d,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Container(
                        height: 20.h,
                        width: 22.w,
                        decoration: BoxDecoration(
                          color: AppColors.greyColor3d,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppColors.greyColor3d,
                  height: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
