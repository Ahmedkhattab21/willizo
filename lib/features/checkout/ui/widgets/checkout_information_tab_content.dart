import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_response_model.dart';
import 'package:willizo/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_order_summary_content.dart';

class CheckoutInformationTabContent extends StatefulWidget {
  final List<CartItem> cartItems;
  final String? addressId;
  final VoidCallback? onContinueToPayment;

  const CheckoutInformationTabContent({
    super.key,
    this.cartItems = const [],
    this.addressId,
    this.onContinueToPayment,
  });

  @override
  State<CheckoutInformationTabContent> createState() =>
      _CheckoutInformationTabContentState();
}

class _CheckoutInformationTabContentState
    extends State<CheckoutInformationTabContent> {
  CheckoutCalculationResponseModel? _lastCalculation;

  @override
  void initState() {
    super.initState();
    // Fetch order summary when addressId is available
    if (widget.addressId != null && widget.addressId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CheckoutCubit>().calculateCheckout(widget.addressId!);
      });
    }
  }

  @override
  void didUpdateWidget(CheckoutInformationTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fetch order summary when addressId changes
    if (widget.addressId != null &&
        widget.addressId!.isNotEmpty &&
        widget.addressId != oldWidget.addressId) {
      context.read<CheckoutCubit>().calculateCheckout(widget.addressId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        if (widget.addressId == null || widget.addressId!.isEmpty) {
          // Show message if no address is selected
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(
                'Please select an address first',
                style: TextStyles.font14GreyColorW400.copyWith(
                  color: AppColors.greyColorColor79,
                ),
              ),
            ),
          );
        }

        // Update last calculation when we get a new one
        if (state is CheckoutCalculationLoaded) {
          _lastCalculation = state.calculation;
        }

        // If we have a previous calculation, keep showing it even when loading
        // (this allows promo code application without full-screen loader)
        if (state is CheckoutLoading && _lastCalculation != null) {
          return CheckoutOrderSummaryContent(
            calculation: _lastCalculation!,
            addressId: widget.addressId!,
            onContinueToPayment: widget.onContinueToPayment,
          );
        }

        // Show loading only on initial load
        if (state is CheckoutLoading) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }

        if (state is CheckoutError) {
          // If we have a previous calculation, show it with error message
          if (_lastCalculation != null) {
            return CheckoutOrderSummaryContent(
              calculation: _lastCalculation!,
              addressId: widget.addressId!,
              onContinueToPayment: widget.onContinueToPayment,
            );
          }
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
              child: Text(
                'Error: ${state.message}',
                style: TextStyles.font14whiteColorColorW400,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is CheckoutCalculationLoaded) {
          final calculation = state.calculation;
          return CheckoutOrderSummaryContent(
            calculation: calculation,
            addressId: widget.addressId!,
            onContinueToPayment: widget.onContinueToPayment,
          );
        }

        // Initial state - show loading or empty
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      },
    );
  }
}
