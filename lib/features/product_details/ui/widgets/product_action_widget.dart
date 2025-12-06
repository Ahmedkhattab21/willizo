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

  const ProductActionButtons({
    super.key,
    required this.onAddToCart,
    required this.onWishlist,
    required this.onShare,
    required this.onBuyNow,
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
                backGroundColor: AppColors.greyColorColorED,
                isLoading: false,
                leadingSvg: ImageAsset.cartIcon,
                buttonText: "Add to Cart",
                textStyle: TextStyles.font16WhiteColorW500.copyWith(
                  color: AppColors.backgroundColor,
                ),
                onPressed: onAddToCart,
              ),
            ),
            _IconButtonWithBorder(
              icon: ImageAsset.heartIcon,
              onPressed: onWishlist,
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

  const _IconButtonWithBorder({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: AppColors.greyColorFB,
          width: 2,
        ),
      ),
      child: IconButton(
        icon: SvgPicture.asset(icon),
        onPressed: onPressed,
      ),
    );
  }
}