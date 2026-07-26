import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/styles.dart';

class CustomSearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomSearchBarWidget({super.key, this.controller, this.onChanged});

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
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: TextStyles.font14greyColorColor79W400.copyWith(
                  color: AppColors.blackColor,
                ),
                decoration: InputDecoration(
                  hintText: "Search friends...",
                  hintStyle: TextStyles.font14greyColorColor79W400.copyWith(
                    color: AppColors.greyColorFD,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
