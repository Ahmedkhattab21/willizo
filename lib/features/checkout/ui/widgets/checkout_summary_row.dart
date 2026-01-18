import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class CheckoutSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;
  final bool isTotal;

  const CheckoutSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isDiscount = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? TextStyles.font16WhiteColorW600.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                )
              : TextStyles.font14GreyColorW400.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.greyColorColor79,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? TextStyles.font16primaryColorW600.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                )
              : isDiscount
                  ? TextStyles.font14whiteColorColorW400.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.greenColor19,
                    )
                  : TextStyles.font14whiteColorColorW400.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}
