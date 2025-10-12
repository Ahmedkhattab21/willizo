import 'package:flutter/material.dart';
import 'package:willizo/features/workout/ui/widgets/work_card_widget.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return WorkoutCard();
      },
    );
  }
}
