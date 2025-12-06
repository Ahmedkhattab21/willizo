import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class TrustBadgesWidget extends StatelessWidget {
  const TrustBadgesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BadgeItem(
          iconPath: ImageAsset.safetyIcon,
          text: "Secure checkout with SSL encryption",
        ),
        verticalSpace(8),
        _BadgeItem(
          iconPath: ImageAsset.blueReturnIcon,
          text: "30-day money-back guarantee",
        ),
        verticalSpace(8),
        _BadgeItem(
          iconPath: ImageAsset.customerServiceIcon,
          text: "100% satisfaction guaranteed",
        ),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final String iconPath;
  final String text;

  const _BadgeItem({required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, height: 16.h, width: 16.w),
        horizontalSpace(8),
        Text(
          text,
          style: TextStyles.font12InterW400.copyWith(
            color: AppColors.greyColorColor79,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
