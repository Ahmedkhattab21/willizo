import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';
import 'package:willizo/features/cart/data/models/checkout_calculation_response_model.dart';

class OrderSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double tax;
  final CheckoutCalculationResponseModel? checkoutData;
  final List<CartItem> cartItems;

  const OrderSummaryWidget({
    super.key,
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.tax = 0.0,
    this.checkoutData,
    this.cartItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Use checkout data if available, otherwise use passed values
    final effectiveSubtotal = checkoutData?.pricing.subtotal ?? subtotal;
    final effectiveDiscount = checkoutData?.pricing.discountAmount ?? discount;
    final effectiveTax = checkoutData?.pricing.taxAmount ?? tax;
    final shippingRate = checkoutData?.pricing.shippingRate ?? 0.0;
    final total =
        checkoutData?.pricing.total ??
        (effectiveSubtotal - effectiveDiscount + effectiveTax + shippingRate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order Summary",
          style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
        ),
        verticalSpace(20),
        _SummaryRow(
          label: "Subtotal",
          value: "\$${effectiveSubtotal.toStringAsFixed(2)}",
        ),
        verticalSpace(12),
        _SummaryRow(
          label: "Discount",
          value: "-\$${effectiveDiscount.toStringAsFixed(2)}",
          valueColor: AppColors.greenColorFC,
        ),
        verticalSpace(12),
        _SummaryRow(
          label: "Tax",
          value: "\$${effectiveTax.toStringAsFixed(2)}",
        ),
        if (shippingRate > 0) ...[
          verticalSpace(12),
          _SummaryRow(
            label: "Shipping",
            value: "\$${shippingRate.toStringAsFixed(2)}",
          ),
        ],
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

        // Buttons
        ButtonWidget(
          isLoading: false,
          buttonText: "Proceed to Checkout",
          textStyle: TextStyles.font14BlackColorW700.copyWith(fontSize: 16.sp),
          onPressed: () {
            context.pushNamed(
              Routes.checkoutScreen,
              arguments: {'cartItems': cartItems},
            );
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
            onPressed: () {
              context.pushNamedAndRemoveUntil(
                Routes.buttonNavBarWidget,
                arguments: {'initialIndex': 1},
                predicate: (route) => false,
              );
            },
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
          style: TextStyles.font14whiteColorColorW400.copyWith(
            color: valueColor ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
