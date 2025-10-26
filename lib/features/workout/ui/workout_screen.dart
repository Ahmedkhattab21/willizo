import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/workout/ui/widgets/excercises_body_widget.dart';
import 'package:willizo/features/workout/ui/widgets/recipe_screen.dart';
import 'package:willizo/features/workout/ui/widgets/workout_tap_bar_widget.dart';

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
              WorkoutTabBar(
                selectedIndex: _selectedIndex,
                onTabSelected: (index) =>
                    setState(() => _selectedIndex = index),
              ),
              verticalSpace(30),
              Expanded(child: _tabs[_selectedIndex]),
            ],
          ),
        ),
      ),
    );
  }
}
