import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.greyColor27,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan',
                      style: TextStyles.font14whiteColorColorW400.copyWith(
                        color: AppColors.greyColorColor80,
                      ),
                    ),
                    verticalSpace(8),
                    Text(
                      'Premium, Family',
                      style: TextStyles.font16WhiteColorW600,
                    ),
                    verticalSpace(6),
                    Text(
                      'Next renewal: Jan 1, 2025',
                      style: TextStyles.font12greyColorColor79W400.copyWith(
                        color: AppColors.greyColorColor80,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text('ACTIVE', style: TextStyles.font14primaryColorW600),
              ),
            ],
          ),
          verticalSpace(20),
          Text(
            'Family',
            style: TextStyles.font14whiteColorColorW400.copyWith(
              color: AppColors.greyColorColor80,
            ),
          ),
          verticalSpace(8),
          Text('2 members', style: TextStyles.font16WhiteColorW600),
        ],
      ),
    );
  }
}
