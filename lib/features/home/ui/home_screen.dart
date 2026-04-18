import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/home/logic/cubit/home_cubit.dart';
import 'package:willizo/features/home/ui/widgets/custom_drawer_widget.dart';
import 'package:willizo/features/home/ui/widgets/date_section_widget.dart';
import 'package:willizo/features/home/ui/widgets/exersise_card_widget.dart';
import 'package:willizo/features/home/ui/widgets/home_top_header_widget.dart';
import 'package:willizo/features/home/ui/widgets/meal_card_widget.dart';
import 'package:willizo/features/home/ui/widgets/section_title_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeTopHeaderWidget(),
                  verticalSpace(18),
                  const DateSelector(),
                  verticalSpace(18),
                  SectionTitle(
                    title: "TODAY'S",
                    accent: 'EXERCISES',
                    color: AppColors.primaryColor,
                  ),
                  verticalSpace(12),
                  if (state.workoutPlansStatus == HomeLoadStatus.loading ||
                      state.workoutPlansStatus == HomeLoadStatus.initial)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  else if (state.workoutPlansStatus == HomeLoadStatus.failure)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        state.workoutPlansError ?? 'Failed to load workouts',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    )
                  else if (state.workouts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'No workouts planned',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    )
                  else
                    ...state.workouts.expand(
                      (w) => [
                        ExerciseCard.fromWorkout(w),
                        verticalSpace(12),
                      ],
                    ),
                  verticalSpace(18),
                  SectionTitle(
                    title: "TODAY'S",
                    accent: 'MEALS',
                    color: AppColors.blueColorF32,
                  ),
                  verticalSpace(12),
                  if (state.mealPlansStatus == HomeLoadStatus.loading ||
                      state.mealPlansStatus == HomeLoadStatus.initial)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(
                          color: AppColors.blueColorF32,
                        ),
                      ),
                    )
                  else if (state.mealPlansStatus == HomeLoadStatus.failure)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        state.mealPlansError ?? 'Failed to load meals',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    )
                  else if (state.meals.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'No meals planned',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    )
                  else
                    ...state.meals.expand(
                      (m) => [
                        MealCard.fromMeal(m),
                        verticalSpace(12),
                      ],
                    ),
                  verticalSpace(30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
