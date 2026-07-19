import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/cart/ui/widgets/trust_badges_widget.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_response_model.dart';
import 'package:willizo/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_item_card.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_summary_row.dart';

class CheckoutOrderSummaryContent extends StatefulWidget {
  final CheckoutCalculationResponseModel calculation;
  final String addressId;
  final VoidCallback? onContinueToPayment;

  const CheckoutOrderSummaryContent({
    super.key,
    required this.calculation,
    required this.addressId,
    this.onContinueToPayment,
  });

  @override
  State<CheckoutOrderSummaryContent> createState() =>
      _CheckoutOrderSummaryContentState();
}

class _CheckoutOrderSummaryContentState
    extends State<CheckoutOrderSummaryContent> {
  final TextEditingController _promoCodeController = TextEditingController();
  bool _isApplying = false;
  bool _isRemovingPromoCode = false;

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  void _applyPromoCode() {
    final promoCode = _promoCodeController.text.trim();
    if (promoCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a promo code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isApplying = true;
    });

    context.read<CheckoutCubit>().calculateCheckout(
      widget.addressId,
      couponCode: promoCode,
    );
  }

  void _removePromoCode() {
    setState(() {
      _isApplying = true;
      _isRemovingPromoCode = true;
      _promoCodeController.clear();
    });

    context.read<CheckoutCubit>().calculateCheckout(widget.addressId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutCalculationLoaded) {
          final wasRemoving = _isRemovingPromoCode;
          setState(() {
            _isApplying = false;
            _isRemovingPromoCode = false;
          });
          if (wasRemoving) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Promo code removed'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.calculation.coupon.valid) {
            final code = state.calculation.coupon.code;
            if (code != null && code.isNotEmpty) {
              _promoCodeController.text = code;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.calculation.coupon.message ??
                      'Coupon applied successfully',
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.calculation.coupon.message ?? 'Invalid coupon code',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else if (state is CheckoutError) {
          setState(() {
            _isApplying = false;
            _isRemovingPromoCode = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
        buildWhen: (previous, current) {
          // Only rebuild when we get a new calculation, not when loading
          return current is CheckoutCalculationLoaded;
        },
        builder: (context, state) {
          // Use the latest calculation from state if available, otherwise use widget.calculation
          final calculation = state is CheckoutCalculationLoaded
              ? state.calculation
              : widget.calculation;
          final hasPromoCode =
              calculation.coupon.valid &&
              (calculation.coupon.code?.isNotEmpty ?? false);
          if (hasPromoCode &&
              _promoCodeController.text != calculation.coupon.code) {
            _promoCodeController.text = calculation.coupon.code ?? '';
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cart Items Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cart Items (${calculation.itemsCount})",
                    style: TextStyles.font18WhiteColor700.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.edit_outlined,
                      color: AppColors.primaryColor,
                      size: 16.sp,
                    ),
                    label: Text(
                      "Edit",
                      style: TextStyles.font14primaryColorW600.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              verticalSpace(20),
              // Cart Items List
              if (calculation.items.isEmpty)
                Center(
                  child: Text(
                    "No items in cart",
                    style: TextStyles.font14GreyColorW400.copyWith(
                      color: AppColors.greyColorColor79,
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: calculation.items.length,
                  separatorBuilder: (context, index) => verticalSpace(12),
                  itemBuilder: (context, index) {
                    final item = calculation.items[index];
                    return CheckoutItemCard(item: item);
                  },
                ),
              verticalSpace(30),
              // Order Summary Section
              Text(
                "Order Summary",
                style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
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
              Divider(color: AppColors.greyColorColor79.withValues(alpha: 0.3)),
              CheckoutSummaryRow(
                label: "Total",
                value: "\$${calculation.pricing.total.toStringAsFixed(2)}",
                isTotal: true,
              ),
              verticalSpace(20),
              // Promo Code
              Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    color: AppColors.primaryColor,
                    size: 16.sp,
                  ),
                  horizontalSpace(8),
                  Text(
                    "Promo Code",
                    style: TextStyles.font14whiteColorColorW400.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
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
                          color: AppColors.greyColorFB.withValues(alpha: 0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _promoCodeController,
                        readOnly: hasPromoCode,
                        style: TextStyles.font14whiteColorColorW400,
                        decoration: InputDecoration(
                          hintText: "Enter code",
                          hintStyle: TextStyles.font14GreyColorW400.copyWith(
                            color: AppColors.greyColorColor79,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(10),
                  GestureDetector(
                    onTap: _isApplying
                        ? null
                        : hasPromoCode
                        ? _removePromoCode
                        : _applyPromoCode,
                    child: Container(
                      height: 45.h,
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      decoration: BoxDecoration(
                        color: _isApplying
                            ? Colors.grey
                            : hasPromoCode
                            ? AppColors.primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: _isApplying
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.blackColor,
                                ),
                              ),
                            )
                          : Text(
                              hasPromoCode ? "Remove Code" : "Apply",
                              style: TextStyles.font14BlackColorW700.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              verticalSpace(20),
              // Continue to Payment Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Move to Payment step
                    widget.onContinueToPayment?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    "Continue to Payment",
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
}
