import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/shop/logic/cubit/badge_cubit.dart';

class ShopHeaderWidget extends StatelessWidget {
  const ShopHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BadgeCubit, BadgeState>(
      builder: (context, badgeState) {
        return Row(
          children: [
            SvgPicture.asset(ImageAsset.appLogoIconTwo, height: 22.h, width: 146.w),
            const Spacer(),
            GestureDetector(
              onTap: () {
                context.pushNamed(Routes.wishlistScreen);
              },
              child: _buildBadgedIcon(
                iconPath: ImageAsset.wishlistIcon,
                count: badgeState.wishlistCount,
              ),
            ),
            horizontalSpace(15.w),
            GestureDetector(
              onTap: () {
                context.pushNamed(Routes.cartScreen);
              },
              child: _buildBadgedIcon(
                iconPath: ImageAsset.shoppingCartIcon,
                count: badgeState.cartCount,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBadgedIcon({required String iconPath, required int count}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          iconPath,
          height: 24.h,
          width: 24.w,
          colorFilter: const ColorFilter.mode(
            AppColors.greyColorColor80,
            BlendMode.srcIn,
          ),
        ),
        if (count > 0)
          Positioned(
            top: -8.h,
            right: -8.w,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(minWidth: 18.r, minHeight: 18.r),
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
