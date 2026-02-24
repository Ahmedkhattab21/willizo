import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/data/models/workout_summary_model.dart';

class WeeklyChallengeCard extends StatelessWidget {
  /// Workout summary from GET /workouts/summary. If null, shows placeholder.
  final WorkoutSummaryModel? workoutSummary;

  const WeeklyChallengeCard({super.key, this.workoutSummary});

  @override
  Widget build(BuildContext context) {
    final summary = workoutSummary;
    final target = summary?.totalValue ?? 0;
    final current = summary?.workoutCount ?? 0;
    final progress = target > 0 ? (current.clamp(0, target) / target) : 0.0;
    final description = summary != null
        ? 'Complete ${summary.totalValue} ${summary.exercise.name} workout'
        : 'Complete reps';
    final progressLabel = '$current/$target';

    return Container(
      width: double.infinity,
      height: 112.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [AppColors.greenColorEF, AppColors.greenColorFD],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Weekly Challenge",
                  style: TextStyles.font16InterW600.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyles.font14InterW400,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                Stack(
                  children: [
                    Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          horizontalSpace(12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                          ImageAsset.fire,
                          width: 15.w,
                          height: 18.w,
                        ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                progressLabel,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
