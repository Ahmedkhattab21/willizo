import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';

class CreateLeagueFormWidget extends StatelessWidget {
  const CreateLeagueFormWidget({super.key});

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
            "League Name",
            style: TextStyle(
              color: AppColors.greyColorColor80,
              fontSize: 14.sp,
              fontFamily: 'Inter',
            ),
          ),
          verticalSpace(8),
          TextFormField(
            style: TextStyle(color: AppColors.whiteColor, fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: "Enter League Name",
              hintStyle: TextStyle(
                color: AppColors.greyColorColor80,
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                Icons.person,
                color: AppColors.greyColorColor80,
                size: 20.sp,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
          verticalSpace(16),
          Text(
            "Please think carefully before entering your league name.Please refer to the Terms & Conditions of entry for more information.",
            style: TextStyle(
              color: AppColors.greyColorColor80,
              fontSize: 12.sp,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          verticalSpace(32),
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.greyColorColor80, // Grey color as per image
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Center(
              child: Text(
                "Create a league",
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
