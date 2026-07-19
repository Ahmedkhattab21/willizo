import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/custom_app_bar_widget.dart';
import 'package:willizo/features/my_order/data/models/orders_response_model.dart';
import 'package:willizo/features/my_order/logic/orders_cubit.dart';
import 'package:willizo/features/product_details/data/models/create_review_request_model.dart';
import 'package:willizo/features/product_details/data/repo/product_details_repo.dart';

class MyOrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const MyOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<MyOrderDetailsScreen> createState() => _MyOrderDetailsScreenState();
}

class _MyOrderDetailsScreenState extends State<MyOrderDetailsScreen> {
  final Set<String> reviewedItems = {};

  Future<void> _openReviewDialog(OrderData order, OrderItemData item) async {
    final submitted = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.76),
      builder: (_) => _WriteOrderReviewDialog(item: item, orderId: order.id),
    );

    if (submitted != true || !mounted) return;

    setState(() => reviewedItems.add(item.id));
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.78),
      builder: (_) => _ReviewSubmittedDialog(productName: item.displayName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      appBar: const CustomAppBar(title: "Order Details"),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrderDetailsCancelError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is OrderDetailsError) {
            return _DetailsMessage(
              message: state.message,
              onRetry: () =>
                  context.read<OrdersCubit>().getOrderDetails(widget.orderId),
            );
          }

          if (state is OrderDetailsLoaded) {
            return _OrderDetailsBody(
              order: state.order,
              reviewedItems: reviewedItems,
              onWriteReview: _openReviewDialog,
              onCancelOrder: _cancelOrder,
            );
          }

          if (state is OrderDetailsCancelling) {
            return _OrderDetailsBody(
              order: state.order,
              reviewedItems: reviewedItems,
              onWriteReview: _openReviewDialog,
              onCancelOrder: _cancelOrder,
              isCancelling: true,
            );
          }

          if (state is OrderDetailsCancelError) {
            return _OrderDetailsBody(
              order: state.order,
              reviewedItems: reviewedItems,
              onWriteReview: _openReviewDialog,
              onCancelOrder: _cancelOrder,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _cancelOrder(OrderData order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => _CancelOrderDialog(orderNumber: order.displayNumber),
    );

    if (confirmed != true || !mounted) return;
    await context.read<OrdersCubit>().cancelOrder(order);
  }
}

class _OrderDetailsBody extends StatelessWidget {
  final OrderData order;
  final Set<String> reviewedItems;
  final Future<void> Function(OrderData order, OrderItemData item)
  onWriteReview;
  final Future<void> Function(OrderData order)? onCancelOrder;
  final bool isCancelling;

  const _OrderDetailsBody({
    required this.order,
    required this.reviewedItems,
    required this.onWriteReview,
    this.onCancelOrder,
    this.isCancelling = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 36.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Items Ordered",
                      style: TextStyles.font18WhiteColor700.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "Order #${order.displayNumber}",
                        textAlign: TextAlign.end,
                        style: TextStyles.font14GreyColorW400.copyWith(
                          color: AppColors.greyColorColor79,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(22),
                ...List.generate(order.items.length, (index) {
                  final item = order.items[index];
                  return Column(
                    children: [
                      _OrderItemCard(
                        item: item,
                        isReviewSubmitted: reviewedItems.contains(item.id),
                        onWriteReview: () => onWriteReview(order, item),
                      ),
                      if (index != order.items.length - 1) ...[
                        verticalSpace(22),
                        Divider(
                          color: AppColors.greyColorColor79.withValues(
                            alpha: 0.35,
                          ),
                        ),
                        verticalSpace(22),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),
          verticalSpace(28),
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Summary",
                  style: TextStyles.font18WhiteColor700.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
                verticalSpace(30),
                Text(
                  "Price Details",
                  style: TextStyles.font16WhiteColorW600.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
                verticalSpace(28),
                _SummaryRow(label: "Order Date:", value: order.displayDate),
                verticalSpace(16),
                _SummaryRow(
                  label: "Order Status:",
                  value: order.statusLabel,
                  valueColor: _statusTextColor(order.status),
                ),
                verticalSpace(16),
                _SummaryRow(
                  label: "Payment Status:",
                  value: order.paymentStatusLabel,
                  valueColor: order.paymentStatusLabel == 'Paid'
                      ? AppColors.blueColorDE
                      : const Color(0xFFFFF2C2),
                ),
                verticalSpace(18),
                Divider(
                  color: AppColors.greyColorColor79.withValues(alpha: 0.35),
                ),
                verticalSpace(18),
                _SummaryRow(
                  label: "Total",
                  value: order.displayTotal,
                  labelStyle: TextStyles.font18WhiteColor700.copyWith(
                    fontSize: 18.sp,
                  ),
                  valueStyle: TextStyles.font18WhiteColor700.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 20.sp,
                  ),
                ),
                verticalSpace(28),
                const _InfoBlock(
                  title: "Payment Information",
                  lines: ["Credit Card (.... 4242)"],
                ),
                verticalSpace(28),
                _InfoBlock(
                  title: "Shipping Information",
                  lines: order.shippingAddress?.displayLines ?? const [],
                ),
                if (_canCancel(order)) ...[
                  verticalSpace(28),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: isCancelling || onCancelOrder == null
                          ? null
                          : () => onCancelOrder?.call(order),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.red,
                        disabledBackgroundColor: Colors.red.withValues(
                          alpha: 0.55,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: isCancelling
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            )
                          : Text(
                              "Cancel Order",
                              style: TextStyles.font16WhiteColorW600.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _canCancel(OrderData order) {
    final status = order.status.toLowerCase();
    return status == 'pending' || status == 'processing';
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.blackColor171C,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final OrderItemData item;
  final bool isReviewSubmitted;
  final VoidCallback onWriteReview;

  const _OrderItemCard({
    required this.item,
    required this.isReviewSubmitted,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.productId.isEmpty
          ? null
          : () => context.pushNamed(
              Routes.productDetailsScreen,
              arguments: {'productId': item.productId},
            ),
      borderRadius: BorderRadius.circular(8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: _ProductImage(imageUrl: item.displayImage),
          ),
          verticalSpace(20),
          Text(
            item.displayName,
            style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
          ),
          verticalSpace(10),
          Text(
            "SKU:  ${item.productSku}",
            style: TextStyles.font14GreyColorW400.copyWith(
              color: AppColors.greyColorColor79,
              fontSize: 16.sp,
            ),
          ),
          verticalSpace(10),
          Text(
            "Quantity: ${item.quantity}",
            style: TextStyles.font14GreyColorW400.copyWith(
              color: AppColors.greyColorColor79,
              fontSize: 16.sp,
            ),
          ),
          verticalSpace(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  item.displayPrice,
                  style: TextStyles.font18WhiteColor700.copyWith(
                    fontSize: 20.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 38.h,
                child: ElevatedButton(
                  onPressed: isReviewSubmitted || item.productId.isEmpty
                      ? null
                      : onWriteReview,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isReviewSubmitted
                        ? AppColors.blueColorDE
                        : AppColors.primaryColor,
                    disabledBackgroundColor: AppColors.blueColorDE,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  child: Text(
                    isReviewSubmitted ? "Review Submitted" : "Write a Review",
                    style: TextStyles.font14W600.copyWith(
                      color: isReviewSubmitted
                          ? const Color(0xFF166534)
                          : AppColors.blackColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;

  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 150.h,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    }
    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return Image.asset(
      ImageAsset.backgroundCardImage,
      width: double.infinity,
      height: 150.h,
      fit: BoxFit.cover,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              labelStyle ??
              TextStyles.font14GreyColorW400.copyWith(
                color: AppColors.greyColorColor79,
                fontSize: 16.sp,
              ),
        ),
        Text(
          value,
          style:
              valueStyle ??
              TextStyles.font14whiteColorColorW400.copyWith(
                color: valueColor ?? AppColors.whiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _InfoBlock({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.font16WhiteColorW600.copyWith(fontSize: 18.sp),
        ),
        verticalSpace(18),
        if (lines.isEmpty)
          Text(
            "Not available",
            style: TextStyles.font14GreyColorW400.copyWith(
              color: AppColors.greyColorColor79,
              fontSize: 16.sp,
            ),
          )
        else
          ...lines.map(
            (line) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                line,
                style: TextStyles.font14GreyColorW400.copyWith(
                  color: AppColors.greyColorColor79,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _WriteOrderReviewDialog extends StatefulWidget {
  final OrderItemData item;
  final String orderId;

  const _WriteOrderReviewDialog({required this.item, required this.orderId});

  @override
  State<_WriteOrderReviewDialog> createState() =>
      _WriteOrderReviewDialogState();
}

class _WriteOrderReviewDialogState extends State<_WriteOrderReviewDialog> {
  int rating = 4;
  bool isLoading = false;
  final titleController = TextEditingController();
  final reviewController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (titleController.text.trim().isEmpty ||
        reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter review title and comment"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    final result = await getIt<ProductDetailsRepo>().createReview(
      CreateReviewRequestModel(
        productId: widget.item.productId,
        rating: rating,
        title: titleController.text.trim(),
        comment: reviewController.text.trim(),
        orderId: widget.orderId,
      ),
    );
    if (!mounted) return;
    setState(() => isLoading = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.message), backgroundColor: Colors.red),
      ),
      (_) => Navigator.of(context).pop(true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF121212),
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Write a Review",
                    style: TextStyles.font16WhiteColorW600,
                  ),
                  IconButton(
                    onPressed: isLoading
                        ? null
                        : () => Navigator.of(context).pop(false),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.greyColorCA,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
              Divider(color: AppColors.greyColorColor79),
              verticalSpace(10),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.greyColor33,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: AppColors.greyColorColor79),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3.r),
                      child: SizedBox(
                        width: 56.w,
                        height: 56.w,
                        child: _ProductImage(
                          imageUrl: widget.item.displayImage,
                        ),
                      ),
                    ),
                    horizontalSpace(14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.displayName,
                            style: TextStyles.font14whiteColorColorW400,
                          ),
                          verticalSpace(4),
                          Text(
                            "From order #${widget.orderId}",
                            style: TextStyles.font12InterWhiteW400.copyWith(
                              color: AppColors.greyColorColor79,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(18),
              Text("Your Rating", style: TextStyles.font12InterWhiteW400),
              verticalSpace(8),
              Row(
                children: List.generate(5, (index) {
                  final active = index < rating;
                  return GestureDetector(
                    onTap: isLoading
                        ? null
                        : () => setState(() => rating = index + 1),
                    child: Icon(
                      active ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFD400),
                      size: 24.sp,
                    ),
                  );
                }),
              ),
              verticalSpace(18),
              _ReviewTextField(
                label: "Review Title",
                hint: "e.g., Best experience ever!",
                controller: titleController,
                enabled: !isLoading,
              ),
              verticalSpace(18),
              _ReviewTextField(
                label: "Your Review",
                hint: "Tell us more about your experience...",
                controller: reviewController,
                enabled: !isLoading,
                maxLines: 4,
              ),
              verticalSpace(22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _DialogButton(
                    text: "Cancel",
                    backgroundColor: AppColors.whiteColor,
                    textColor: AppColors.greyColorColor79,
                    onPressed: isLoading
                        ? null
                        : () => Navigator.of(context).pop(false),
                  ),
                  horizontalSpace(12),
                  _DialogButton(
                    text: "Submit Review",
                    backgroundColor: AppColors.primaryColor,
                    textColor: AppColors.blackColor,
                    onPressed: isLoading ? null : _submit,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final bool enabled;

  const _ReviewTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.font12InterWhiteW400),
        verticalSpace(8),
        TextField(
          enabled: enabled,
          controller: controller,
          maxLines: maxLines,
          style: TextStyles.font14whiteColorColorW400,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyles.font12InterWhiteW400.copyWith(
              color: AppColors.greyColorColor79,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.4),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewSubmittedDialog extends StatelessWidget {
  final String productName;

  const _ReviewSubmittedDialog({required this.productName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF121212),
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 42.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: const BoxDecoration(
                color: Color(0xFF005F25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: AppColors.greenColorEF,
                size: 28.sp,
              ),
            ),
            verticalSpace(28),
            Text(
              "Review Submitted!",
              style: TextStyles.font18WhiteColor700.copyWith(fontSize: 22.sp),
            ),
            verticalSpace(14),
            Text(
              "Thank you for sharing your feedback\n$productName. Your review helps other\ncustomers make informed decisions.",
              textAlign: TextAlign.center,
              style: TextStyles.font14GreyColorW400.copyWith(
                color: AppColors.greyColorColor79,
                height: 1.55,
              ),
            ),
            verticalSpace(28),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    text: "View My Orders",
                    backgroundColor: AppColors.primaryColor,
                    textColor: AppColors.blackColor,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: _OutlinedDialogButton(
                    text: "Back to Account",
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pushNamedAndRemoveUntil(
                        Routes.buttonNavBarWidget,
                        arguments: {'initialIndex': 4},
                        predicate: (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelOrderDialog extends StatelessWidget {
  final String orderNumber;

  const _CancelOrderDialog({required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF121212),
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 44.sp),
            verticalSpace(18),
            Text(
              "Cancel Order?",
              style: TextStyles.font18WhiteColor700.copyWith(fontSize: 20.sp),
            ),
            verticalSpace(12),
            Text(
              "Are you sure you want to cancel order #$orderNumber?",
              textAlign: TextAlign.center,
              style: TextStyles.font14GreyColorW400.copyWith(
                color: AppColors.greyColorColor79,
                height: 1.45,
              ),
            ),
            verticalSpace(24),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    text: "No",
                    backgroundColor: AppColors.whiteColor,
                    textColor: AppColors.greyColorColor79,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: _DialogButton(
                    text: "Cancel Order",
                    backgroundColor: Colors.red,
                    textColor: AppColors.whiteColor,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _DialogButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Text(
                text,
                style: TextStyles.font14W600.copyWith(color: textColor),
              ),
      ),
    );
  }
}

class _OutlinedDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _OutlinedDialogButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
        ),
        child: Text(
          text,
          style: TextStyles.font14W600.copyWith(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

class _DetailsMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _DetailsMessage({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.font16WhiteColorW500,
            ),
            if (onRetry != null) ...[
              verticalSpace(16),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.blackColor,
                ),
                child: const Text("Retry"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Color _statusTextColor(String status) {
  final normalized = status.toLowerCase();
  if (normalized == 'cancelled' || normalized == 'canceled') {
    return AppColors.whiteColorFE;
  }
  if (normalized == 'pending') return const Color(0xFFFFF2C2);
  return AppColors.blueColorDE;
}
