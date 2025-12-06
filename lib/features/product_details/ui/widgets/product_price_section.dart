import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class ProductPriceSection extends StatelessWidget {
  final double currentPrice;
  final double? originalPrice;
  final int? discountPercentage;

  const ProductPriceSection({
    super.key,
    required this.currentPrice,
    this.originalPrice,
    this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("\$$currentPrice", style: TextStyles.font24PrimaryColorW700),
        if (originalPrice != null) ...[
          SizedBox(width: 10.w),
          Text(
            "\$$originalPrice",
            style: TextStyles.font16GreyColorW500.copyWith(
              decoration: TextDecoration.lineThrough,
              decorationThickness: 2,
              decorationColor: AppColors.greyColorF7,
            ),
          ),
        ],
        if (discountPercentage != null) ...[
          horizontalSpace(10),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.redColorF7,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              "$discountPercentage% OFF",
              style: TextStyles.font14InterW600.copyWith(
                color: AppColors.whiteColorFE,
              ),
            ),
          ),
        ],
      ],
    );
  }
}