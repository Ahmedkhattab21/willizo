import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/features/workout/ui/widgets/workout_tap_itme_widget.dart';

class WorkoutTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const WorkoutTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        spacing: 8.w,
        children: [
          Expanded(
            child: WorkoutTabItem(
              svgPath: ImageAsset.coloredDoumble,
              label: 'Exercises',
              isSelected: selectedIndex == 0,
              onTap: () => onTabSelected(0),
            ),
          ),

          Expanded(
            child: WorkoutTabItem(
              icon: Icons.restaurant,
              label: 'Recipes',
              isSelected: selectedIndex == 1,
              onTap: () => onTabSelected(1),
            ),
          ),
        ],
      ),
    );
  }
}
