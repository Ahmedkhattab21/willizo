import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class CheckoutConfirmationTabContent extends StatelessWidget {
  const CheckoutConfirmationTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        verticalSpace(20),
        SvgPicture.asset(ImageAsset.confirmationIcon),
        verticalSpace(24),
        Text(
          "Payment Successful!",
          style: TextStyles.font18WhiteColor700.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpace(12),
        // Success Message
        Text(
          "Thank you for your purchase. Your\nFitness journey starts now.",
          style: TextStyles.font14GreyColorW400.copyWith(
            fontSize: 14.sp,
            color: AppColors.greyColorColor79,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpace(40),
        // Order Summary Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.greyColorColor79.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.greyColorColor79.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order Summary",
                style: TextStyles.font18WhiteColor700.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              verticalSpace(20),
              _buildOrderDetailRow("Order Number", "FF-2024-18454"),
              verticalSpace(16),
              Divider(color: AppColors.greyColorColor79.withOpacity(0.3)),
              verticalSpace(16),
              _buildOrderDetailRow("Item", "T-shirt"),
              verticalSpace(16),
              Divider(color: AppColors.greyColorColor79.withOpacity(0.3)),
              verticalSpace(16),
              _buildOrderDetailRow("Amount Paid", "\$871.97", isAmount: true),
            ],
          ),
        ),
        // Next Steps Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.greyColorColor79.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.greyColorColor79.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Next Steps",
                style: TextStyles.font18WhiteColor700.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              verticalSpace(16),
              Text(
                "A confirmation email has been sent to your\naddress with details. Welcome to Willizo\nfamily!",
                style: TextStyles.font14GreyColorW400.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.greyColorColor79,
                ),
              ),
            ],
          ),
        ),
        verticalSpace(40),
        // Back To Homepage Button
        SizedBox(
          width: 189.w,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () {
              // Navigate back to homepage
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Back To Homepage",
              style: TextStyles.font16WhiteColorW600.copyWith(
                color: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        verticalSpace(40),
      ],
    );
  }

  Widget _buildOrderDetailRow(
    String label,
    String value, {
    bool isAmount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.font14GreyColorW400.copyWith(
            fontSize: 14.sp,
            color: AppColors.greyColorColor79,
          ),
        ),
        Text(
          value,
          style: isAmount
              ? TextStyles.font16WhiteColorW600.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                )
              : TextStyles.font14whiteColorColorW400.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}
