import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/workout/data/models/body_part_exercises_response_model.dart';
import 'package:willizo/features/workout/data/repo/body_parts_repo.dart';
import 'package:willizo/features/workout/logic/cubit/body_part_exercises_cubit.dart';
import 'package:willizo/features/workout/ui/utils/body_part_icon_mapper.dart';

class BodyPartExercisesList extends StatelessWidget {
  const BodyPartExercisesList({
    super.key,
    required this.slug,
    required this.icon,
  });

  final String slug;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BodyPartExercisesCubit(getIt<BodyPartsRepo>())..fetchExercises(slug),
      child: BlocBuilder<BodyPartExercisesCubit, BodyPartExercisesState>(
        builder: (context, state) {
          if (state.status == BodyPartExercisesLoadStatus.loading ||
              state.status == BodyPartExercisesLoadStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state.status == BodyPartExercisesLoadStatus.failure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.errorMessage ?? 'Failed to load exercises',
                    style: TextStyles.font14InterW400.copyWith(
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(10),
                  TextButton(
                    onPressed: () => context
                        .read<BodyPartExercisesCubit>()
                        .fetchExercises(slug),
                    child: Text(
                      'Retry',
                      style: TextStyles.font14W700.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.exercises.isEmpty) {
            return Center(
              child: Text(
                'No exercises available',
                style: TextStyles.font16GreyColorW500,
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            itemCount: state.exercises.length,
            separatorBuilder: (_, __) => verticalSpace(8),
            itemBuilder: (context, index) {
              final exercise = state.exercises[index];
              return _ExerciseTile(exercise: exercise, icon: icon);
            },
          );
        },
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({required this.exercise, required this.icon});

  final BodyPartExerciseModel exercise;
  final String icon;

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
              BodyPartIconMapper.assetForGroup(icon),
              width: 18.w,
              height: 18.w,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: TextStyles.font16White2ColorW600.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
                verticalSpace(2),
                Text(
                  exercise.category,
                  style: TextStyles.font14GreyColorW400.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryColor),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_forward,
              color: AppColors.primaryColor,
              size: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
