import 'package:flutter/material.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/widgets/custom_app_bar_widget.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';
import 'package:willizo/features/workout/ui/widgets/exercises/body_part_exercises_list.dart';

class MuscleExercisesScreen extends StatelessWidget {
  const MuscleExercisesScreen({super.key, required this.child});

  final BodyPartChildModel child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: child.name),
      body: BodyPartExercisesList(slug: child.slug, icon: child.icon),
    );
  }
}
