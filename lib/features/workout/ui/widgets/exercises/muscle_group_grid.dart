import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';
import 'package:willizo/features/workout/ui/widgets/exercises/muscle_group_card.dart';

class MuscleGroupGrid extends StatelessWidget {
  const MuscleGroupGrid({super.key, required this.groups});

  final List<BodyPartModel> groups;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Muscle Groups',
          style: TextStyles.font18WhiteInterW600.copyWith(fontSize: 16.sp),
        ),
        verticalSpace(8),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
              childAspectRatio: 1.65,
            ),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return MuscleGroupCard(group: groups[index]);
            },
          ),
        ),
      ],
    );
  }
}
