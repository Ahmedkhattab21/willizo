import 'package:flutter/material.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/custom_app_bar_widget.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';

class MuscleExercisesScreen extends StatelessWidget {
  const MuscleExercisesScreen({super.key, required this.child});

  final BodyPartChildModel child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: child.name),
      body: Center(
        child: Text(
          'Coming soon',
          style: TextStyles.font16GreyColorW500,
        ),
      ),
    );
  }
}
