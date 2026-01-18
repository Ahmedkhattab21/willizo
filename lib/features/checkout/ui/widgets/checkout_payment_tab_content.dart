import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/cart/ui/widgets/trust_badges_widget.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_response_model.dart';
import 'package:willizo/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_summary_row.dart';

class CheckoutPaymentTabContent extends StatefulWidget {
  final CheckoutCalculationResponseModel? calculation;
  final VoidCallback? onOrderConfirmed;

  const CheckoutPaymentTabContent({
    super.key,
    this.calculation,
    this.onOrderConfirmed,
  });

  @override
  State<CheckoutPaymentTabContent> createState() =>
      _CheckoutPaymentTabContentState();
}

class _CheckoutPaymentTabContentState extends State<CheckoutPaymentTabContent> {
  String _selectedPaymentMethod = 'credit_card';
  bool _isProcessing = false;
  CheckoutCalculationResponseModel? _lastCalculation;

  @override
  void initState() {
    super.initState();
    _lastCalculation = widget.calculation;
  }

  @override
  void didUpdateWidget(CheckoutPaymentTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update last calculation when new one is provided
    if (widget.calculation != null) {
      _lastCalculation = widget.calculation;
    }
  }

  void _completePurchase() {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    context.read<CheckoutCubit>().confirmCheckout();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutOrderConfirmed) {
          // Navigate to confirmation tab immediately
          // Don't reset _isProcessing here - button will disappear on navigation anyway
          widget.onOrderConfirmed?.call();
        } else if (state is CheckoutError) {
          setState(() {
            _isProcessing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
        buildWhen: (previous, current) {
          // Only rebuild when calculation changes, not on loading or order confirmed
          // (we handle order confirmed in listener to avoid button disappearing)
          return current is CheckoutCalculationLoaded;
        },
        builder: (context, state) {
          // Update last calculation if we get a new one
          if (state is CheckoutCalculationLoaded) {
            _lastCalculation = state.calculation;
          }
          
          // Use last calculation to keep showing it even when loading
          final calculation = _lastCalculation ?? widget.calculation;
          
          return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Payment Information Header
        Row(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "2",
                  style: TextStyles.font14W700.copyWith(
                    color: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            horizontalSpace(8),
            Text(
              "Payment Information",
              style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
            ),
          ],
        ),
        verticalSpace(20),
        // Payment Method Selection
        Row(
          children: [
            Expanded(
              child: _buildPaymentMethodButton(
                'credit_card',
                'Credit Card',
                Icons.credit_card,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: _buildPaymentMethodButton(
                'apple_pay',
                'Apple Pay',
                Icons.apple,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: _buildPaymentMethodButton(
                'paypal',
                'PayPal',
                Icons.payment,
              ),
            ),
          ],
        ),
        verticalSpace(20),
        // Payment Form Fields (shown only for credit card)
        if (_selectedPaymentMethod == 'credit_card') ...[
          _buildPaymentField(
            icon: Icons.credit_card,
            label: "Card Number",
            hintText: "1234 5678 9012 3456",
          ),
          verticalSpace(16),
          _buildPaymentField(
            icon: Icons.calendar_today,
            label: "Expiry Date",
            hintText: "MM/YY",
          ),
          verticalSpace(16),
          _buildPaymentField(
            icon: Icons.lock_outline,
            label: "CVV",
            hintText: "123",
          ),
          verticalSpace(16),
          _buildPaymentField(
            icon: Icons.person_outline,
            label: "Cardholder Name",
            hintText: "John Doe",
          ),
          verticalSpace(30),
        ],
            // Order Summary Section
            if (calculation != null) ...[
              Text(
                "Order Summary",
                style: TextStyles.font18WhiteColor700.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              verticalSpace(16),
              CheckoutSummaryRow(
                label: "Subtotal",
                value: "\$${calculation.pricing.subtotal.toStringAsFixed(2)}",
              ),
              verticalSpace(12),
              CheckoutSummaryRow(
                label: "Discount",
                value: calculation.pricing.discountAmount > 0
                    ? "-\$${calculation.pricing.discountAmount.toStringAsFixed(2)}"
                    : "\$0.00",
                isDiscount: true,
              ),
              verticalSpace(12),
              CheckoutSummaryRow(
                label: "Tax (${calculation.pricing.taxRatePercentage})",
                value: "\$${calculation.pricing.taxAmount.toStringAsFixed(2)}",
              ),
              verticalSpace(16),
              Divider(color: AppColors.greyColorColor79.withOpacity(0.3)),
              verticalSpace(16),
              CheckoutSummaryRow(
                label: "Total",
                value: "\$${calculation.pricing.total.toStringAsFixed(2)}",
                isTotal: true,
              ),
            ],
            verticalSpace(30),
            // Complete Purchase Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _completePurchase,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
                icon: _isProcessing
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.blackColor,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.shopping_bag,
                        color: AppColors.blackColor,
                        size: 20.sp,
                      ),
                label: Text(
                  _isProcessing ? "Processing..." : "Complete Purchase",
                  style: TextStyles.font16WhiteColorW600.copyWith(
                    color: AppColors.blackColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            verticalSpace(30),
            // Trust Badges
            const TrustBadgesWidget(),
          ],
        );
        },
      ),
    );
  }

  Widget _buildPaymentMethodButton(String method, String label, IconData icon) {
    final isSelected = _selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyColorColor79.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.blackColor
                  : AppColors.greyColorColor79,
              size: 18.sp,
            ),
            horizontalSpace(6),
            Flexible(
              child: Text(
                label,
                style: TextStyles.font14W600.copyWith(
                  color: isSelected
                      ? AppColors.blackColor
                      : AppColors.greyColorColor79,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentField({
    required IconData icon,
    required String label,
    required String hintText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryColor, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 20.sp),
          horizontalSpace(12),
          Expanded(
            child: Text(
              hintText,
              style: TextStyles.font14whiteColorColorW400.copyWith(
                fontSize: 14.sp,
                color: AppColors.greyColorColor79,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
