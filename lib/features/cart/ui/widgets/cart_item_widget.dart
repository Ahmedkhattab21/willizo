import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class CartItemWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final double price;
  final double originalPrice;
  final int discount;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              imageUrl,
              height: 180.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          verticalSpace(12),
          // Title & Subtitle
          Text(
            title,
            style: TextStyles.font16WhiteColorW600.copyWith(fontSize: 16.sp),
          ),
          verticalSpace(4),
          Text(
            subtitle,
            style: TextStyles.font14GreyColorW400.copyWith(
              fontSize: 12.sp,
              color: AppColors.greyColorColor79,
            ),
          ),
          verticalSpace(12),
          // Price Row
          Row(
            children: [
              Text(
                "\$${price.toStringAsFixed(2)}",
                style: TextStyles.font16primaryColorW600.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              horizontalSpace(8),
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    "\$${originalPrice.toStringAsFixed(2)}",
                    style: TextStyles.font14GreyColorW400.copyWith(
                      color: AppColors.greyColorColor79,
                      fontSize: 12.sp,
                    ),
                  ),
                  Container(
                    height: 1.h,
                    width: 40.w, // Approximate width of the text
                    color: AppColors.greyColorColor79,
                  ),
                ],
              ),
              horizontalSpace(8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.redColor39,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  "$discount% OFF",
                  style: TextStyles.font10WhiteColorW600.copyWith(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(12),
          // Actions Row
          Row(
            children: [
              // Quantity Selector
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyColorColor79),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: onRemove,
                      isActive: false,
                    ),
                    Container(
                      width: 1.w,
                      height: 32.h,
                      color: AppColors.greyColorColor79,
                    ),
                    Container(
                      width: 40.w,
                      alignment: Alignment.center,
                      child: Text(
                        "$quantity",
                        style: TextStyles.font14whiteColorColorW400.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    Container(
                      width: 1.w,
                      height: 32.h,
                      color: AppColors.greyColorColor79,
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: onAdd,
                      isActive: true,
                    ),
                  ],
                ),
              ),
              Spacer(),
              // Remove Button
              InkWell(
                onTap: onDelete,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImageAsset.deleteIcon,
                      colorFilter: ColorFilter.mode(
                        AppColors.redColor,
                        BlendMode.srcIn,
                      ),
                      height: 18.h,
                      width: 18.w,
                    ),
                    horizontalSpace(4),
                    Text(
                      "Remove",
                      style: TextStyles.font14W600.copyWith(
                        color: AppColors.redColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : Colors.transparent,
          borderRadius: isActive
              ? BorderRadius.only(
                  topRight: Radius.circular(6.r),
                  bottomRight: Radius.circular(6.r),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(6.r),
                  bottomLeft: Radius.circular(6.r),
                ),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: isActive ? Colors.black : AppColors.greyColorColor79,
        ),
      ),
    );
  }
}
