import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';

class JoinInvitationalLeagueWidget extends StatelessWidget {
  const JoinInvitationalLeagueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Join an Invitational League",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          verticalSpace(32),
          Text(
            "League Code",
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
              hintText: "Enter League Code",
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
          verticalSpace(32),
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors
                  .greyColorColor80, // Grey color for disabled/default state
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(30.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImageAsset.enterIcon,
                      colorFilter: const ColorFilter.mode(
                        AppColors.blackColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    horizontalSpace(8),
                    Text(
                      "Join a league",
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
