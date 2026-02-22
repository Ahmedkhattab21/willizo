import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class ProfileStatItem extends StatelessWidget {
  final String number;
  final String label;
  final Color? numberColor;

  const ProfileStatItem({
    super.key,
    required this.number,
    required this.label,
    this.numberColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyles.fon32whiteColorW700.copyWith(
              color: numberColor ?? AppColors.whiteColor,
              fontSize: 24.sp,
            ),
          ),
          Text(
            label,
            style: TextStyles.font12WhiteColorW500.copyWith(
              color: AppColors.greyColor75,
            ),
          ),
        ],
      ),
    );
  }
}
