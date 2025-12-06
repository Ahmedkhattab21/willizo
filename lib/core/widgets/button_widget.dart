import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/app_colors_white_theme.dart';

class ButtonWidget extends StatelessWidget {
  final bool isLoading;
  final double? borderRadius;
  final Color? borderColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? borderWidth;
  final Color? backGroundColor;
  final Color? fourGroundColor;
  final Color? iconColor;
  final double? buttonWidth;
  final double? buttonHeight;
  final String buttonText;
  final IconData? icon;
  final IconData? leadingIcon;

  final String? leadingSvg; // SVG قبل النص
  final String? svgIcon; // SVG بعد النص

  final TextStyle textStyle;
  final VoidCallback? onPressed;

  const ButtonWidget({
    super.key,
    required this.isLoading,
    this.borderRadius,
    this.borderColor,
    this.iconColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.borderWidth,
    this.backGroundColor,
    this.fourGroundColor,
    this.buttonHeight,
    this.buttonWidth,
    this.icon,
    this.leadingIcon,
    this.leadingSvg,
    this.svgIcon,
    required this.buttonText,
    required this.textStyle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: buttonHeight ?? 50.h,
        width: buttonWidth?.w ?? double.maxFinite,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding?.w ?? 12.w,
          vertical: verticalPadding?.h ?? 6.h,
        ),
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
          border: Border.all(
            color: borderColor ?? AppColors.whiteColor,
            width: borderWidth ?? 0,
          ),
        ),
        child: isLoading
            ? LoadingWidget(color: fourGroundColor ?? AppColors.whiteColor)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingSvg != null) ...[
                    SvgPicture.asset(leadingSvg!, width: 18.r, height: 18.r),
                    horizontalSpace(10),
                  ],
                  if (leadingIcon != null && leadingSvg == null) ...[
                    Icon(
                      leadingIcon,
                      color: iconColor ?? AppColors.whiteColor,
                      size: 18.r,
                    ),
                    horizontalSpace(6),
                  ],

                  /// ----------- Text ----------
                  Text(buttonText, style: textStyle),

                  /// ----------- trailing SVG ----------
                  if (svgIcon != null) ...[
                    horizontalSpace(6),
                    SvgPicture.asset(
                      svgIcon!,
                      width: 18.r,
                      height: 18.r,
                      color: iconColor,
                    ),
                  ],

                  if (icon != null && svgIcon == null) ...[
                    horizontalSpace(6),
                    Icon(icon, color: iconColor, size: 18.r),
                  ],
                ],
              ),
      ),
    );
  }
}
