import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class AddressTypeButton extends StatelessWidget {
  final String type;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressTypeButton({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected
                ? AppColors.blackColor
                : AppColors.greyColorColor80,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
