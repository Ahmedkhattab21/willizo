import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class ProductRatingBadge extends StatelessWidget {
  final bool inStock;
  final double rating;
  final int reviewCount;

  const ProductRatingBadge({
    super.key,
    required this.inStock,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.greenColorF3,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            inStock ? "In Stock" : "Out of Stock",
            style: TextStyles.font10WhiteColorW600.copyWith(
              color: AppColors.blackColor,
            ),
          ),
        ),
        Spacer(),
        ..._buildStars(rating),
        SizedBox(width: 6.w),
        Text(
          "($reviewCount reviews)",
          style: TextStyle(color: AppColors.greyColorF9, fontSize: 12.sp),
        ),
      ],
    );
  }

  List<Widget> _buildStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow, size: 18.sp));
    }

    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow, size: 18.sp));
    }

    int remainingStars = 5 - stars.length;
    for (int i = 0; i < remainingStars; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.yellow, size: 18.sp));
    }

    return stars;
  }
}
