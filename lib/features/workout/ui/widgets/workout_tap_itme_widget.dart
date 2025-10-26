import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class WorkoutTabItem extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const WorkoutTabItem({
    super.key,
    this.icon,
    this.svgPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? Colors.black : Colors.grey;
    final bgColor = isSelected
        ? AppColors.primaryColor
        : AppColors.backgroundColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgPath != null)
              SvgPicture.asset(
                svgPath!,
                width: 20.w,
                height: 20.w,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              )
            else if (icon != null)
              Icon(icon, color: iconColor, size: 20.w),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyles.font14PrimaryColorW600.copyWith(
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
