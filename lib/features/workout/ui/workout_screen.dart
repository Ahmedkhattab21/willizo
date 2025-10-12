import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/workout/ui/widgets/excercises_body_widget.dart';
import 'package:willizo/features/workout/ui/widgets/recipe_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [WorkoutListScreen(), RecipeScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              _buildTabBar(),
              const SizedBox(height: 30),
              Expanded(child: _tabs[_selectedIndex]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              svgPath: ImageAsset.coloredDoumble,
              label: 'Exercises',
              isSelected: _selectedIndex == 0,
              onTap: () => setState(() => _selectedIndex = 0),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildTab(
              icon: Icons.restaurant,
              label: 'Recipes',
              isSelected: _selectedIndex == 1,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    IconData? icon,
    String? svgPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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
                svgPath,
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
