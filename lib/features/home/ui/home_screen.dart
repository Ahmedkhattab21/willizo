import 'package:flutter/material.dart';
import 'package:willizo/features/home/ui/widgets/custom_drawer_widget.dart';
import 'package:willizo/features/home/ui/widgets/home_top_header_widget.dart';
import 'package:willizo/features/home/ui/widgets/date_section_widget.dart';
import 'package:willizo/features/home/ui/widgets/exersise_card_widget.dart';
import 'package:willizo/features/home/ui/widgets/meal_card_widget.dart';
import 'package:willizo/features/home/ui/widgets/section_title_text.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
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
              const ExerciseCard(),
              verticalSpace(12),
              const ExerciseCard(),
              verticalSpace(18),
              SectionTitle(
                title: "TODAY'S",
                accent: 'MEALS',
                color: AppColors.blueColorF32,
              ),
              verticalSpace(12),
              const MealCard(),
              verticalSpace(12),
              const MealCard(),
              verticalSpace(30),
            ],
          ),
        ),
      ),
    );
  }
}
