import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/styles.dart';

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color Options",
          style: TextStyles.font14W600.copyWith(
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: List.generate(colors.length, (index) {
            return GestureDetector(
              onTap: () => onColorSelected(index),
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedIndex == index
                        ? Colors.white
                        : Colors.transparent,
                    width: 3,
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