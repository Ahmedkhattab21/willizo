import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/custom_app_bar_widget.dart';
import 'package:willizo/features/my_order/data/models/orders_response_model.dart';
import 'package:willizo/features/my_order/logic/orders_cubit.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      appBar: const CustomAppBar(title: "My Orders"),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is OrdersError) {
            return _OrdersMessage(
              message: state.message,
              onRetry: () => context.read<OrdersCubit>().getOrders(),
            );
          }

          if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return const _OrdersMessage(message: "No orders yet");
            }

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(18.w, 26.h, 18.w, 36.h),
              itemCount: state.orders.length,
              separatorBuilder: (context, index) => verticalSpace(18),
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return _OrderCard(
                  order: order,
                  onTap: () => context.pushNamed(
                    Routes.myOrderDetailsScreen,
                    arguments: {'id': order.id},
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderData order;
  final VoidCallback onTap;

  const _OrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 22.h),
        decoration: BoxDecoration(
          color: AppColors.blackColor171C,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _InfoColumn(
                    label: "Order #",
                    value: order.displayNumber,
                  ),
                ),
                horizontalSpace(16),
                Expanded(
                  child: _InfoColumn(label: "Date", value: order.displayDate),
                ),
              ],
            ),
            verticalSpace(24),
            Row(
              children: [
                Expanded(
                  child: _InfoColumn(label: "Total", value: order.displayTotal),
                ),
                horizontalSpace(16),
                Expanded(
                  child: _InfoColumn(
                    label: "Items",
                    value: order.itemsCount.toString(),
                  ),
                ),
              ],
            ),
            verticalSpace(28),
            _StatusChip(status: order.status),
          ],
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.font16WhiteColorW600.copyWith(
            color: AppColors.greyColorCA,
            fontSize: 16.sp,
          ),
        ),
        verticalSpace(8),
        Text(
          value,
          style: TextStyles.font16WhiteColorW500.copyWith(fontSize: 20.sp),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.toLowerCase();
    final colors = switch (normalizedStatus) {
      'delivered' || 'completed' => (
        background: AppColors.blueColorDE,
        foreground: const Color(0xFF166534),
        label: "Delivered",
      ),
      'cancelled' || 'canceled' => (
        background: AppColors.whiteColorFE,
        foreground: const Color(0xFF7F1D1D),
        label: "Cancelled",
      ),
      _ => (
        background: const Color(0xFFFFF2C2),
        foreground: const Color(0xFF7C5A00),
        label: "Processing",
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        colors.label,
        style: TextStyles.font16WhiteColorW500.copyWith(
          color: colors.foreground,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}

class _OrdersMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _OrdersMessage({required this.message, this.onRetry});

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
