import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';

class ProductActionButtons extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onWishlist;
  final VoidCallback onShare;
  final VoidCallback onBuyNow;
  final bool isAddToCartLoading;
  final bool isWishlistLoading;
  final bool isAdded;
  final bool isInWishlist;

  const ProductActionButtons({
    super.key,
    required this.onAddToCart,
    required this.onWishlist,
    required this.onShare,
    required this.onBuyNow,
    this.isAddToCartLoading = false,
    this.isWishlistLoading = false,
    this.isAdded = false,
    this.isInWishlist = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 10.w,
          children: [
            Expanded(
              child: ButtonWidget(
                borderRadius: 4.r,
                backGroundColor: isAdded
                    ? AppColors.greyColorFB
                    : AppColors.greyColorColorED,
                isLoading: isAddToCartLoading,
                leadingSvg: isAdded ? null : ImageAsset.cartIcon,
                buttonText: isAdded ? "Added to Cart" : "Add to Cart",
                textStyle: TextStyles.font16WhiteColorW500.copyWith(
                  color: isAdded ? Colors.white : AppColors.backgroundColor,
                ),
                onPressed: isAdded ? null : onAddToCart,
              ),
            ),
            _IconButtonWithBorder(
              icon: ImageAsset.heartIcon,
              onPressed: onWishlist,
              isLoading: isWishlistLoading,
              iconColor: isInWishlist ? AppColors.primaryColor : null,
            ),
            _IconButtonWithBorder(
              icon: ImageAsset.sharetIcon,
              onPressed: onShare,
            ),
          ],
        ),
        SizedBox(height: 14.h),
        ButtonWidget(
          backGroundColor: AppColors.primaryColor,
          isLoading: false,
          buttonText: "Buy Now",
          borderRadius: 4.r,
          textStyle: TextStyles.font16InterW600.copyWith(
            color: AppColors.blackColor,
          ),
          onPressed: onBuyNow,
        ),
      ],
    );
  }
}

class _IconButtonWithBorder extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? iconColor;

  const _IconButtonWithBorder({
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.greyColorFB, width: 2),
      ),
      child: isLoading
          ? Padding(
              padding: EdgeInsets.all(12.r),
              child: SizedBox(
                width: 24.r,
                height: 24.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          : IconButton(
              icon: SvgPicture.asset(
                icon,
                colorFilter: iconColor != null
                    ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                    : null,
              ),
              onPressed: onPressed,
            ),
    );
  }
}
