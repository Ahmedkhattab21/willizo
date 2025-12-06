import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/custom_app_bar_widget.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      appBar: const CustomAppBar(title: "My Orders"),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        itemCount: _orders.length,
        separatorBuilder: (context, index) => verticalSpace(16),
        itemBuilder: (context, index) {
          return _OrderCard(order: _orders[index]);
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.blackColor171C,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn("Order #", order.orderNumber),
              _buildInfoColumn("Date", order.date),
            ],
          ),
          verticalSpace(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn("Total", order.total),
              _buildInfoColumn("Items", order.itemsCount.toString()),
            ],
          ),
          verticalSpace(20),
          _StatusChip(status: order.status),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.font12InterWhiteW400.copyWith(
              color: AppColors.greyColorColor80,
            ),
          ),
          verticalSpace(4),
          Text(value, style: TextStyles.font16WhiteColorW500),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case OrderStatus.delivered:
        backgroundColor = AppColors.blueColorDE; // Light green
        textColor = AppColors.greenColor7; // Dark green
        text = "Delivered";
        break;
      case OrderStatus.processing:
        backgroundColor = const Color(0xFFFEF3C7); // Light yellow
        textColor = const Color(0xFF92400E); // Dark orange/brown
        text = "Processing";
        break;
      case OrderStatus.cancelled:
        backgroundColor = AppColors.whiteColorFE; // Light pink
        textColor = AppColors.redColorF7; // Dark red
        text = "Cancelled";
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyles.font14InterW400.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

enum OrderStatus { delivered, processing, cancelled }

class OrderModel {
  final String orderNumber;
  final String date;
  final String total;
  final int itemsCount;
  final OrderStatus status;

  OrderModel({
    required this.orderNumber,
    required this.date,
    required this.total,
    required this.itemsCount,
    required this.status,
  });
}

final List<OrderModel> _orders = [
  OrderModel(
    orderNumber: "ORD-2023-120A",
    date: "Oct 26, 2023",
    total: "\$149.99",
    itemsCount: 3,
    status: OrderStatus.delivered,
  ),
  OrderModel(
    orderNumber: "ORD-2023-120A",
    date: "Oct 26, 2023",
    total: "\$149.99",
    itemsCount: 3,
    status: OrderStatus.processing,
  ),
  OrderModel(
    orderNumber: "ORD-2023-120A",
    date: "Oct 26, 2023",
    total: "\$149.99",
    itemsCount: 3,
    status: OrderStatus.cancelled,
  ),
];
