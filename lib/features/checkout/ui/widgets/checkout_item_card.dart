import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_response_model.dart';

class CheckoutItemCard extends StatelessWidget {
  final CheckoutItemModel item;

  const CheckoutItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: item.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      item.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        color: AppColors.greyColorColor79,
                        size: 30.sp,
                      ),
                    ),
                  )
                : Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.greyColorColor79,
                    size: 30.sp,
                  ),
          ),
          horizontalSpace(12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyles.font14whiteColorColorW400.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.variantName != null) ...[
                  verticalSpace(4),
                  Text(
                    item.variantName!,
                    style: TextStyles.font14GreyColorW400.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.greyColorColor79,
                    ),
                  ),
                ],
                verticalSpace(4),
                Text(
                  "Qty: ${item.quantity}",
                  style: TextStyles.font14GreyColorW400.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.greyColorColor79,
                  ),
                ),
              ],
            ),
          ),
          // Price
          Text(
            "\$${item.subtotal.toStringAsFixed(2)}",
            style: TextStyles.font16primaryColorW600.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
