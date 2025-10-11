import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/styles.dart';

class SearchAndFilterWidget extends StatelessWidget {
  const SearchAndFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: Container(
            height: 35.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.greyColorColorED,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              spacing: 10.w,
              children: [
                SvgPicture.asset(ImageAsset.searchIcon),

                Text('Search', style: TextStyles.font17GreyColorW400),
              ],
            ),
          ),
        ),
        Container(
          height: 40.h,
          width: 40.w,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: SvgPicture.asset(ImageAsset.filterIcon),
        ),
      ],
    );
  }
}
