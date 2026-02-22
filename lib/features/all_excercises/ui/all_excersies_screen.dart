import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/features/community/data/models/exercise_category_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  static String _getIconAsset(String iconName) {
    switch (iconName) {
      case 'push-ups':
        return ImageAsset.coloredDoumble;
      case 'squats':
        return ImageAsset.squatsIcon;
      case 'pull-ups':
        return ImageAsset.pullUpsIcon;
      case 'plank':
        return ImageAsset.plankIcon;
      case 'chest-bench':
        return ImageAsset.coloredDoumble;
      case 'chest-fly':
        return ImageAsset.coloredDoumble;
      case 'deadlift':
        return ImageAsset.coloredDoumble;
      case 'rows':
        return ImageAsset.coloredDoumble;
      case 'lunges':
        return ImageAsset.squatsIcon;
      case 'leg-press':
        return ImageAsset.squatsIcon;
      case 'bicep-curl':
        return ImageAsset.coloredDoumble;
      case 'tricep-dip':
        return ImageAsset.coloredDoumble;
      case 'crunches':
        return ImageAsset.plankIcon;
      case 'twists':
        return ImageAsset.plankIcon;
      case 'running':
        return ImageAsset.squatsIcon;
      case 'cycling':
        return ImageAsset.squatsIcon;
      case 'jump-rope':
        return ImageAsset.squatsIcon;
      case 'burpees':
        return ImageAsset.squatsIcon;
      case 'climbers':
        return ImageAsset.squatsIcon;
      case 'yoga':
        return ImageAsset.plankIcon;
      case 'overhead-press':
        return ImageAsset.overheadPressIcon;
      default:
        return ImageAsset.coloredDoumble;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        if (state is LeaderboardLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final categories = state is LeaderboardLoadedState
            ? state.exerciseCategories
            : <ExerciseCategoryEntry>[];

        if (categories.isEmpty) {
          return Center(
            child: Text(
              'No exercises yet',
              style: TextStyle(
                color: AppColors.greyColorD1,
                fontSize: 16.sp,
              ),
            ),
          );
        }

        return ListView(
          children: [
            for (final entry in categories)
              ExerciseCard(
                icon: _getIconAsset(entry.exercise.icon),
                title: entry.exercise.name,
                iconColor: AppColors.primaryColor,
              ),
          ],
        );
      },
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String icon;
  final String title;
  final Color iconColor;

  const ExerciseCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Color(0xFF1A1F0A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(color: Colors.transparent),
            child: SvgPicture.asset(
              icon,
              color: iconColor,
              width: 32.w,
              height: 32.h,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_forward,
              color: AppColors.primaryColor,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
