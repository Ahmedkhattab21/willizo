import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Section
          SvgPicture.asset(ImageAsset.appLogoIcon),
          verticalSpace(20),
          Text(
            "Transform your body, elevate your mind.\nJoin thousands who've achieved their\nfitness goals with our state-of-the-art\nequipment and expert trainers.",
            style: TextStyles.font14InterW600.copyWith(
              color: AppColors.greyColorD1,
              fontWeight: FontWeight.w400,
            ),
          ),
          verticalSpace(20),

          Row(
            children: [
              _SocialIcon(iconPath: ImageAsset.facebookIconFill),
              horizontalSpace(10),
              _SocialIcon(iconPath: ImageAsset.instagramIcon),
              horizontalSpace(10),
              _SocialIcon(iconData: Icons.alternate_email),
              horizontalSpace(10),
              _SocialIcon(iconPath: ImageAsset.youtubeIcon),
            ],
          ),
          verticalSpace(30),
          // Programs Section
          Text(
            "Programs",
            style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
          ),
          verticalSpace(15),
          _FooterLink(text: "Weight Training"),
          _FooterLink(text: "Cardio Workouts"),
          _FooterLink(text: "CrossFit Classes"),
          _FooterLink(text: "Yoga & Pilates"),
          _FooterLink(text: "Personal Training"),
          verticalSpace(30),
          // Services Section
          Text(
            "Services",
            style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
          ),
          verticalSpace(15),
          _FooterLink(text: "Nutrition Coaching"),
          _FooterLink(text: "Meal Planning"),
          _FooterLink(text: "Body Composition"),
          _FooterLink(text: "Recovery Therapy"),
          _FooterLink(text: "Group Classes"),
          verticalSpace(30),
          // Contact Info Section
          Text(
            "Contact Info",
            style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
          ),
          verticalSpace(20),
          _ContactItem(
            icon: Icons.location_on,
            text: "123 Fitness Street\nNew York, NY 10001",
          ),
          verticalSpace(15),
          _ContactItem(icon: Icons.phone, text: "(555) 123-4567"),
          verticalSpace(15),
          _ContactItem(icon: Icons.email, text: "info@fitzone.com"),
          verticalSpace(15),
          _ContactItem(
            icon: Icons.access_time_filled,
            text: "Mon-Fri: 5AM - 11PM\nSat-Sun: 6AM - 10PM",
          ),
          verticalSpace(30),
          Divider(color: AppColors.blueColorF2, thickness: 2),
          verticalSpace(30),
          // Stay Updated Section
          Text(
            "Stay Updated",
            style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
          ),
          verticalSpace(15),
          Text(
            "Subscribe to our newsletter for fitness tips,\nworkout plans, and exclusive offers.",
            style: TextStyles.font14InterW600.copyWith(
              color: AppColors.greyColorD1,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          verticalSpace(20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 32.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.blueColorF2,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.greyColorFB.withOpacity(0.3),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter your email",
                    style: TextStyles.font10GreyColorW400,
                  ),
                ),
              ),
              horizontalSpace(10),
              Container(
                height: 32.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.greenColorEF, AppColors.greenColorFD],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Text(
                      "Subscribe",
                      style: TextStyles.font14InterW600.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    horizontalSpace(8),
                    SvgPicture.asset(ImageAsset.sendIcon),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(40),
          Center(
            child: Text(
              "© 2023 WILLIZO Gym. All rights reserved.",
              style: TextStyles.font12InterW400.copyWith(
                color: AppColors.greyColorColor80,
              ),
            ),
          ),
          verticalSpace(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Cookie Policy",
                style: TextStyles.font12InterW400.copyWith(
                  color: AppColors.greyColorColor80,
                ),
              ),
              horizontalSpace(20),
              Text(
                "Privacy Policy",
                style: TextStyles.font12InterW400.copyWith(
                  color: AppColors.greyColorColor80,
                ),
              ),
              horizontalSpace(20),
              Text(
                "Terms of Service",
                style: TextStyles.font12InterW400.copyWith(
                  color: AppColors.greyColorColor80,
                ),
              ),
            ],
          ),
          verticalSpace(20),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final String? iconPath;
  final IconData? iconData;

  const _SocialIcon({this.iconPath, this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blueColorF2,
      ),
      child: Center(
        child: iconPath != null
            ? SvgPicture.asset(
                iconPath!,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.whiteColorE5,
                  BlendMode.srcIn,
                ),
              )
            : Icon(iconData, color: Colors.white, size: 20.sp),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;

  const _FooterLink({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(
            Icons.arrow_forward_ios,
            size: 12.sp,
            color: AppColors.greyColorD1,
          ),
          horizontalSpace(10),
          Text(
            text,
            style: TextStyles.font16InterW600.copyWith(
              color: AppColors.greyColorD1,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20.sp),
        horizontalSpace(12),
        Text(
          text,
          style: TextStyles.font14InterW400.copyWith(
            color: AppColors.greyColorD1,
            fontSize: 14.sp,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
