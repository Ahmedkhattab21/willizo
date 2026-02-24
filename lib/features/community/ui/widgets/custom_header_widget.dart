import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const CustomHeader({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              height: 30.h,
              width: 30.w,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor, width: 1.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(ImageAsset.arrowBackIcon),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyles.font24primaryColorW600.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ),

          horizontalSpace(30),
        ],
      ),
    );
  }
}
