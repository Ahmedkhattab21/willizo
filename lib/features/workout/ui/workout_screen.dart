import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/workout/logic/cubit/body_parts_cubit.dart';
import 'package:willizo/features/workout/logic/cubit/recipes_cubit.dart';
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
  late final BodyPartsCubit _bodyPartsCubit;
  late final RecipesCubit _recipesCubit;

  @override
  void initState() {
    super.initState();
    _bodyPartsCubit = BodyPartsCubit(getIt())..fetchBodyParts();
    _recipesCubit = RecipesCubit(getIt())..fetchRecipes();
  }

  @override
  void dispose() {
    _bodyPartsCubit.close();
    _recipesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      BlocProvider.value(
        value: _bodyPartsCubit,
        child: const WorkoutListScreen(),
      ),
      BlocProvider.value(
        value: _recipesCubit,
        child: const RecipeScreen(),
      ),
    ];

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
              verticalSpace(_selectedIndex == 0 ? 16 : 30),
              Expanded(child: tabs[_selectedIndex]),
            ],
          ),
        ),
      ),
    );
  }
}
