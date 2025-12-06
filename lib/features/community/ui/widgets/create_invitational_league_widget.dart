import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';

class CreateInvitationalLeagueWidget extends StatelessWidget {
  final VoidCallback? onCreateLeague;

  const CreateInvitationalLeagueWidget({super.key, this.onCreateLeague});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create an Invitational League",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          verticalSpace(8),
          Text(
            "Create your own league and add your friends.",
            style: TextStyle(
              color: AppColors.greyColorColor80,
              fontSize: 14.sp,
              fontFamily: 'Inter',
            ),
          ),
          verticalSpace(32),
          Text(
            "Classic Leagues",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          verticalSpace(8),
          Text(
            "In a league with classic scoring, teams are ranked based on their total points in the game. You can join or leave a league with classic scoring at any point during the season.",
            style: TextStyle(
              color: AppColors.greyColorColor80,
              fontSize: 14.sp,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          verticalSpace(24),
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.greenColorEF, AppColors.greenColorFD],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCreateLeague ?? () {},
                borderRadius: BorderRadius.circular(30.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.blackColor, size: 24.sp),
                    horizontalSpace(8),
                    Text(
                      "Create a league",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
