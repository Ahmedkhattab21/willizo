import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';

class OrderSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double tax;

  const OrderSummaryWidget({
    super.key,
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.tax = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal - discount + tax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order Summary",
          style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
        ),
        verticalSpace(20),
        _SummaryRow(label: "Subtotal", value: "\$${subtotal.toStringAsFixed(2)}"),
        verticalSpace(12),
        _SummaryRow(
          label: "Discount",
          value: "-\$${discount.toStringAsFixed(2)}",
          valueColor: AppColors.greenColorFC,
        ),
        verticalSpace(12),
        _SummaryRow(label: "Tax", value: "\$${tax.toStringAsFixed(2)}"),
        verticalSpace(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: TextStyles.font16WhiteColorW600.copyWith(fontSize: 18.sp),
            ),
            Text(
              "\$${total.toStringAsFixed(2)}",
              style: TextStyles.font16primaryColorW600.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        verticalSpace(20),
        // Promo Code
        Row(
          children: [
            Icon(Icons.local_offer, color: AppColors.primaryColor, size: 16.sp),
            horizontalSpace(8),
            Text(
              "Promo Code",
              // style: TextStyles.font14WhiteColorColorW400.copyWith(
              //   fontWeight: FontWeight.w500,
              // ),
            ),
          ],
        ),
        verticalSpace(10),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 45.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff1e1e1e),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.greyColorFB.withOpacity(0.3),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter code",
                  style: TextStyles.font14GreyColorW400.copyWith(
                    color: AppColors.greyColorColor79,
                  ),
                ),
              ),
            ),
            horizontalSpace(10),
            Container(
              height: 45.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                "Apply",
                style: TextStyles.font14BlackColorW700.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        verticalSpace(20),
        // Buttons
        ButtonWidget(
          isLoading: false,
          buttonText: "Proceed to Checkout",
          textStyle: TextStyles.font14BlackColorW700.copyWith(fontSize: 16.sp),
          onPressed: () {
            context.pushNamed(Routes.checkoutScreen);
          },
          backGroundColor: AppColors.primaryColor,
          borderRadius: 8.r,
          leadingSvg: ImageAsset.visaIcon,
        ),
        verticalSpace(12),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Continue Shopping",
              style: TextStyles.font14primaryColorW600.copyWith(
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.font14GreyColorW400.copyWith(
            color: AppColors.greyColorColor79,
          ),
        ),
        Text(
          value,
          // style: TextStyles.font14WhiteColorColorW400.copyWith(
          //   color: valueColor ?? Colors.white,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
      ],
    );
  }
}
