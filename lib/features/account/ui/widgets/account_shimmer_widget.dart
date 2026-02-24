import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class AccountShimmerWidget extends StatelessWidget {
  const AccountShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor3d,
      highlightColor: AppColors.greyColor75.withValues(alpha: 0.5),
      period: const Duration(milliseconds: 1200),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor3d,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        height: 24.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: AppColors.greyColor3d,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Container(
                    width: 64.r,
                    height: 64.r,
                    decoration: const BoxDecoration(
                      color: AppColors.greyColor3d,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18.h,
                          width: 140.w,
                          decoration: BoxDecoration(
                            color: AppColors.greyColor3d,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 14.h,
                          width: 180.w,
                          decoration: BoxDecoration(
                            color: AppColors.greyColor3d,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 14.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: AppColors.greyColor3d,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: AppColors.greyColor3d,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: List.generate(6, (_) {
                        return SizedBox(
                          width: 100.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 10.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: AppColors.greyColor3d,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Container(
                                height: 14.h,
                                width: 90.w,
                                decoration: BoxDecoration(
                                  color: AppColors.greyColor3d,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor3d,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Container(
                height: 16.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.greyColor3d,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 32.h,
                          width: 48.w,
                          decoration: BoxDecoration(
                            color: AppColors.greyColor3d,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          height: 12.h,
                          width: 120.w,
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
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
