import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';
import 'package:willizo/features/workout/ui/muscle_group_exercises_screen.dart';
import 'package:willizo/features/workout/ui/utils/body_part_icon_mapper.dart';

class MuscleGroupCard extends StatelessWidget {
  const MuscleGroupCard({super.key, required this.group});

  final BodyPartModel group;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.blackColor1E,
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => MuscleGroupExercisesScreen(group: group),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 12.h, 12.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              const Spacer(),
              Text(
                group.name,
                style: TextStyles.font16White2ColorW600.copyWith(
                  fontSize: 13.sp,
                ),
              ),
              verticalSpace(2),
              Text(
                '${group.exerciseCount} exercises',
                style: TextStyles.font14GreyColorW400.copyWith(fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor.withValues(alpha: 0.1),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        BodyPartIconMapper.assetForGroup(group.icon),
        width: 17.w,
        height: 17.w,
        fit: BoxFit.contain,
      ),
    );
  }
}
