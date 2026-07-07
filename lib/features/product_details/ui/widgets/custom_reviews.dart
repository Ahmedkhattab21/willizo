import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/product_details/data/models/create_review_request_model.dart';
import 'package:willizo/features/product_details/logic/cubit/product_details_cubit.dart';
import 'package:willizo/features/product_details/ui/widgets/write_review_dialog.dart';

class CustomReviews extends StatelessWidget {
  final String productId;
  final double rating;
  final int reviewCount;

  const CustomReviews({
    super.key,
    required this.productId,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Customer Reviews",
            style: TextStyles.font24InterW700.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
          verticalSpace(40),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyles.font24InterW700.copyWith(
              color: AppColors.whiteColor,
              fontSize: 64.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                color: index < rating.floor()
                    ? const Color(0xFFFFD700)
                    : Colors.grey,
                size: 28.sp,
              );
            }),
          ),
          SizedBox(height: 8.h),
          Text(
            "Based on $reviewCount reviews",
            style: TextStyles.font14InterW400.copyWith(
              color: AppColors.greyColorCA,
            ),
          ),
          verticalSpace(24),
          const ReviewBar(
            label: "5 stars",
            percentage: 0.75,
            percentText: "75%",
          ),
          SizedBox(height: 12.h),
          const ReviewBar(
            label: "4 stars",
            percentage: 0.18,
            percentText: "18%",
          ),
          SizedBox(height: 12.h),
          const ReviewBar(
            label: "3 stars",
            percentage: 0.05,
            percentText: "5%",
          ),
          SizedBox(height: 12.h),
          const ReviewBar(
            label: "2 stars",
            percentage: 0.01,
            percentText: "1%",
          ),
          SizedBox(height: 12.h),
          const ReviewBar(
            label: "1 stars",
            percentage: 0.01,
            percentText: "1%",
          ),
          SizedBox(height: 24.h),
          ButtonWidget(
            backGroundColor: AppColors.primaryColor,
            isLoading: false,
            buttonText: "Write a Review",
            textStyle: TextStyles.font14InterW600.copyWith(
              color: AppColors.blackColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => WriteReviewDialog(
                  onSubmit:
                      ({required rating, required title, required comment}) {
                        return context.read<ProductDetailsCubit>().createReview(
                          CreateReviewRequestModel(
                            productId: productId,
                            rating: rating,
                            title: title,
                            comment: comment,
                          ),
                        );
                      },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ReviewBar extends StatelessWidget {
  final String label;
  final double percentage;
  final String percentText;

  const ReviewBar({
    super.key,
    required this.label,
    required this.percentage,
    required this.percentText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Star label
        SizedBox(
          width: 60.w,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 8.w),

        // Progress bar
        Expanded(
          child: Stack(
            children: [
              // Background bar
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              // Foreground bar (filled)
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCDDC39), // Lime green
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),

        // Percentage text
        SizedBox(
          width: 35.w,
          child: Text(
            percentText,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
