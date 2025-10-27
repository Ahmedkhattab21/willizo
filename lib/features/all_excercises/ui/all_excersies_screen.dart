import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExerciseCard(
          icon: ImageAsset.coloredDoumble,
          title: 'Bench Press',
          iconColor: AppColors.primaryColor,
        ),
        ExerciseCard(
          icon: ImageAsset.squatsIcon,
          title: 'Squat',
          iconColor: AppColors.primaryColor,
        ),
        ExerciseCard(
          icon: ImageAsset.pullUpsIcon,
          title: 'Pull Ups',
          iconColor: AppColors.primaryColor,
        ),
        ExerciseCard(
          icon: ImageAsset.plankIcon,
          title: 'Plank',
          iconColor: AppColors.primaryColor,
        ),
        ExerciseCard(
          icon: ImageAsset.overheadPressIcon,
          title: 'Overhead Press',
          iconColor: AppColors.primaryColor,
        ),
        ExerciseCard(
          icon: ImageAsset.overheadPressIcon,
          title: 'Bicep Curls',
          iconColor: AppColors.primaryColor,
        ),
      ],
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
