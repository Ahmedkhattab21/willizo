import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final int selectedIndex;
  final ValueChanged<int> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedIndex,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Size",
          style: TextStyles.font14W600.copyWith(
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(sizes.length, (index) {
            final selected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onSizeSelected(index),
              child: Container(
                height: 32.h,
                width: 32.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? AppColors.primaryColor
                        : AppColors.greyColorF2,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    sizes[index],
                    style: TextStyles.font14W600.copyWith(
                      color: selected
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}