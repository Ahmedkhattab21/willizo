import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/my_order/data/models/orders_response_model.dart';
import 'package:willizo/features/my_order/data/repos/orders_repo.dart';
import 'package:willizo/features/my_order/logic/orders_cubit.dart';

class CheckoutConfirmationTabContent extends StatelessWidget {
  final String? orderId;

  const CheckoutConfirmationTabContent({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    final id = orderId;
    if (id == null || id.isEmpty) {
      return _buildProblemContent(
        context,
        message: 'Order number is missing. Please check your orders.',
      );
    }

    return BlocProvider(
      create: (_) => OrdersCubit(getIt<OrdersRepo>())..getOrderDetails(id),
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrderDetailsLoading || state is OrdersInitial) {
            return _buildLoadingContent();
          }
          if (state is OrderDetailsLoaded) {
            return _buildResultContent(context, state.order);
          }
          if (state is OrderDetailsError) {
            return _buildProblemContent(context, message: state.message);
          }
          return _buildLoadingContent();
        },
      ),
    );
  }

  Widget _buildLoadingContent() {
    return SizedBox(
      height: 420.h,
      width: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildResultContent(BuildContext context, OrderData order) {
    final hasProblem = _hasPaymentProblem(order);
    final itemTitle = order.items.length == 1
        ? order.items.first.displayName
        : '${order.itemsCount} items';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        verticalSpace(20),
        hasProblem
            ? Icon(Icons.error_outline, size: 48.w, color: Colors.red)
            : SvgPicture.asset(ImageAsset.confirmationIcon),
        verticalSpace(24),
        Text(
          hasProblem ? "Payment Problem" : "Payment Successful!",
          style: TextStyles.font18WhiteColor700.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpace(12),
        Text(
          hasProblem
              ? "There is a problem with your payment.\nPlease check your order status."
              : "Thank you for your purchase. Your\nFitness journey starts now.",
          style: TextStyles.font14GreyColorW400.copyWith(
            fontSize: 14.sp,
            color: AppColors.greyColorColor79,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpace(40),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.greyColorColor79.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.greyColorColor79.withValues(alpha: 0.2),
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
              _buildOrderDetailRow("Order Number", order.displayNumber),
              verticalSpace(16),
              Divider(color: AppColors.greyColorColor79.withValues(alpha: 0.3)),
              verticalSpace(16),
              _buildOrderDetailRow("Item", itemTitle),
              verticalSpace(16),
              Divider(color: AppColors.greyColorColor79.withValues(alpha: 0.3)),
              verticalSpace(16),
              _buildOrderDetailRow(
                hasProblem ? "Amount" : "Amount Paid",
                order.displayTotal,
                isAmount: true,
              ),
              verticalSpace(16),
              Divider(color: AppColors.greyColorColor79.withValues(alpha: 0.3)),
              verticalSpace(16),
              _buildOrderDetailRow("Payment Status", order.paymentStatusLabel),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.greyColorColor79.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.greyColorColor79.withValues(alpha: 0.2),
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
                hasProblem
                    ? "If money was deducted, contact support with\nyour order number."
                    : "A confirmation email has been sent to your\naddress with details. Welcome to Willizo\nfamily!",
                style: TextStyles.font14GreyColorW400.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.greyColorColor79,
                ),
              ),
            ],
          ),
        ),
        verticalSpace(40),
        SizedBox(
          width: 189.w,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () {
              context.pushNamedAndRemoveUntil(
                Routes.buttonNavBarWidget,
                predicate: (_) => false,
              );
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

  Widget _buildProblemContent(BuildContext context, {required String message}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        verticalSpace(80),
        Icon(Icons.error_outline, size: 48.w, color: Colors.red),
        verticalSpace(24),
        Text(
          "Payment Problem",
          style: TextStyles.font18WhiteColor700.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpace(12),
        Text(
          message,
          style: TextStyles.font14GreyColorW400.copyWith(
            fontSize: 14.sp,
            color: AppColors.greyColorColor79,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpace(40),
        SizedBox(
          width: 189.w,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () => context.pushNamedAndRemoveUntil(
              Routes.buttonNavBarWidget,
              predicate: (_) => false,
            ),
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

  bool _hasPaymentProblem(OrderData order) {
    final normalized = order.status.toLowerCase();
    return normalized == 'failed' ||
        normalized == 'cancelled' ||
        normalized == 'canceled';
  }
}
