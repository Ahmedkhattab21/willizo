import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/custom_app_bar_widget.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';
import 'package:willizo/features/workout/ui/utils/body_part_icon_mapper.dart';

class MuscleGroupExercisesScreen extends StatelessWidget {
  const MuscleGroupExercisesScreen({super.key, required this.group});

  final BodyPartModel group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: group.name),
      body: group.children.isEmpty
          ? Center(
              child: Text(
                'No sub-categories available',
                style: TextStyles.font16GreyColorW500,
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
              itemCount: group.children.length,
              separatorBuilder: (_, __) => verticalSpace(8),
              itemBuilder: (context, index) {
                final child = group.children[index];
                return _BodyPartChildTile(child: child);
              },
            ),
    );
  }
}

class _BodyPartChildTile extends StatelessWidget {
  const _BodyPartChildTile({required this.child});

  final BodyPartChildModel child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.blackColor1E,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withValues(alpha: 0.1),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              BodyPartIconMapper.assetForMuscle(child.icon),
              width: 18.w,
              height: 18.w,
              fit: BoxFit.contain,
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: TextStyles.font16White2ColorW600.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
                verticalSpace(2),
                Text(
                  '${child.exerciseCount} exercises',
                  style: TextStyles.font14GreyColorW400.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
