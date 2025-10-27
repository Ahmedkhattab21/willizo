import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CustomAppBar({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBack ?? () => context.pop(),
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
          ),

          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyles.font24primaryColorW600.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),

          horizontalSpace(30),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
