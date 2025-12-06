import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class MyOrderDetailsScreen extends StatelessWidget {
  const MyOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      appBar: AppBar(
        backgroundColor: AppColors.darkColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primaryColor,
              size: 20.sp,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Order Details",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Items Ordered Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Items Ordered",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  "Order #ORD-2023-120A",
                  style: TextStyle(
                    color: AppColors.greyColorColor80,
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Item 1
            _buildOrderItem(
              imagePath:
                  "https://storage.googleapis.com/a1aa/image/8Xw4Xw4Xw4Xw4Xw4Xw4Xw4Xw4Xw4Xw4Xw.jpg", // Placeholder
              title: "Premium Gym Membership",
              color: "Black",
              quantity: 1,
              price: "\$75.00",
              showReviewButton: true,
              isReviewSubmitted: false,
            ),
            SizedBox(height: 24.h),

            // Item 2
            _buildOrderItem(
              imagePath:
                  "https://storage.googleapis.com/a1aa/image/9Yz5Yz5Yz5Yz5Yz5Yz5Yz5Yz5Yz5Yz5Yz.jpg", // Placeholder
              title: "Premium Gym Membership",
              color: "Black",
              quantity: 1,
              price: "\$75.00",
              showReviewButton: true,
              isReviewSubmitted: true,
            ),
            SizedBox(height: 32.h),

            // Order Summary
            Text(
              "Order Summary",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 16.h),

            // Price Details
            Text(
              "Price Details",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 12.h),

            _buildSummaryRow("Order Date:", "Oct 26, 2023"),
            _buildSummaryRow(
              "Order Status:",
              "Delivered",
              valueColor: AppColors.greenColorFC,
            ),
            _buildSummaryRow(
              "Payment Status:",
              "Paid",
              valueColor: AppColors.greenColorFC,
            ),

            SizedBox(height: 12.h),
            Divider(color: AppColors.greyColorColor80.withOpacity(0.3)),
            SizedBox(height: 12.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  "\$871.97",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Payment Information
            Text(
              "Payment Information",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Credit Card (•••• 4242)",
              style: TextStyle(
                color: AppColors.greyColorColor80,
                fontSize: 14.sp,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 24.h),

            // Shipping Information
            Text(
              "Shipping Information",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "John Doe",
              style: TextStyle(
                color: AppColors.greyColorColor80,
                fontSize: 14.sp,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              "123 Main Street",
              style: TextStyle(
                color: AppColors.greyColorColor80,
                fontSize: 14.sp,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              "Anytown, USA",
              style: TextStyle(
                color: AppColors.greyColorColor80,
                fontSize: 14.sp,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              "12345",
              style: TextStyle(
                color: AppColors.greyColorColor80,
                fontSize: 14.sp,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem({
    required String imagePath,
    required String title,
    required String color,
    required int quantity,
    required String price,
    required bool showReviewButton,
    required bool isReviewSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 150.h,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: NetworkImage(
                "https://placehold.co/600x400/png",
              ), // Using a reliable placeholder
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          title,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "Color: $color",
          style: TextStyle(
            color: AppColors.greyColorColor80,
            fontSize: 14.sp,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "Quantity: $quantity",
          style: TextStyle(
            color: AppColors.greyColorColor80,
            fontSize: 14.sp,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              price,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            if (showReviewButton)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isReviewSubmitted
                      ? AppColors.greyColorColorED.withOpacity(0.8)
                      : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  isReviewSubmitted ? "Review Submitted" : "Write a Review",
                  style: TextStyle(
                    color: isReviewSubmitted
                        ? AppColors.darkColor
                        : AppColors.blackColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.greyColorColor80,
              fontSize: 14.sp,
              fontFamily: 'Inter',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.whiteColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
