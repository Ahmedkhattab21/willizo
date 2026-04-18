import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/home/data/models/my_workout_plans_response_model.dart';

class ExerciseCard extends StatelessWidget {
  final String topCategoryLabel;
  final String planName;
  final String description;
  final String durationLabel;
  final String? scheduledTimeLabel;

  const ExerciseCard._({
    required this.topCategoryLabel,
    required this.planName,
    required this.description,
    required this.durationLabel,
    this.scheduledTimeLabel,
  });

  factory ExerciseCard.fromWorkout(ScheduledWorkoutModel workout) {
    final plan = workout.workoutPlan;
    final top = plan.category.isNotEmpty
        ? plan.category.replaceAll('_', ' ').toUpperCase()
        : 'EXERCISES';
    final du = plan.durationMinutes;
    final durationLabel =
        du != null && du > 0 ? '$du Min' : '--';
    final sched = _formatScheduledTime(workout.scheduledTime);
    return ExerciseCard._(
      topCategoryLabel: top,
      planName: plan.name.isNotEmpty ? plan.name : 'Workout',
      description: plan.description,
      durationLabel: durationLabel,
      scheduledTimeLabel: sched,
    );
  }

  static String? _formatScheduledTime(String raw) {
    if (raw.isEmpty) return null;
    final parts = raw.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAsset.backgroundCardImage),
          fit: BoxFit.fill,
        ),
        gradient: const LinearGradient(
          colors: [AppColors.kCardGreenStart, AppColors.kCardGreenEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.kCardGreenStart.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      ImageAsset.muscleIcon,
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topCategoryLabel,
                        style: TextStyles.font16BlackColorW400.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      Text(
                        planName,
                        style: TextStyles.font12BlackColorColorW500,
                      ),
                      if (scheduledTimeLabel != null) ...[
                        verticalSpace(4),
                        Text(
                          scheduledTimeLabel!,
                          style: TextStyles.font12BlackColorColorW500.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                      verticalSpace(8),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  children: [
                    Icon(Icons.more_vert, color: Colors.black54),
                  ],
                ),
              ],
            ),
            Text(
              description.isNotEmpty
                  ? description
                  : 'No description',
              style: TextStyles.font12W700.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.7,
              ),
            ),
            verticalSpace(14),
            Row(
              children: [
                ButtonWidget(
                  isLoading: false,
                  buttonText: 'Start',
                  textStyle: TextStyles.font14PrimaryColorW600,
                  icon: Icons.arrow_forward,
                  iconColor: AppColors.primaryColor,
                  backGroundColor: Colors.black,
                  borderRadius: 40,
                  buttonWidth: 94.w,
                  buttonHeight: 41.h,
                  horizontalPadding: 18.w,
                  verticalPadding: 10.h,
                  onPressed: () {},
                ),
                horizontalSpace(12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18.r,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        durationLabel,
                        style: TextStyles.font14BlackColorW700.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
