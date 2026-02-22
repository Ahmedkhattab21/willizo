import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/styles.dart';

class CustomSearchBarWidget extends StatelessWidget {
  const CustomSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.whiteColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          spacing: 12.w,
          children: [
            SvgPicture.asset(ImageAsset.coloredSearchIcon),
            Text(
              "Search friends...",
              style: TextStyles.font14greyColorColor79W400.copyWith(
                color: AppColors.greyColorFD,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
