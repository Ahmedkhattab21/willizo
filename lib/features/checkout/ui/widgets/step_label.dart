import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class StepLabel extends StatelessWidget {
  final String title;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback onTap;

  const StepLabel({
    super.key,
    required this.title,
    required this.isActive,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: isActive
            ? TextStyles.font14primaryColorW600.copyWith(
                color: AppColors.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              )
            : TextStyles.font14GreyColorW400.copyWith(
                color: AppColors.greyColorColor79,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
      ),
    );
  }
}
