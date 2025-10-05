import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      width: 0.75.sw,
      decoration: const BoxDecoration(
        color: AppColors.greyColorColor00,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpace(40.h),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SvgPicture.asset(
                ImageAsset.appLogoIconTwo,
                height: 22.h,
                width: 146.w,
              ),
            ),
          ),
          verticalSpace(24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(2),
                  child: CircleAvatar(
                    radius: 25.r,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3',
                    ),
                  ),
                ),
                horizontalSpace(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mohamed Seyam',
                      style: TextStyles.font16PrimaryColorW600,
                    ),
                    Text(
                      'mh159988658@gmail.com',
                      style: TextStyles.font12GreenColorW400.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          verticalSpace(24.h),
          _buildMenuItem(ImageAsset.overviewIcon, 'Overview', isSelected: true),
          _buildMenuItem(ImageAsset.shopingIcon, 'Shop'),
          _buildMenuItem(ImageAsset.calenderIcon, 'Scheduled', badgeCount: 2),
          _buildMenuItem(ImageAsset.releasedIcon, 'Released'),
          verticalSpace(8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Preferences',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
            ),
          ),
          verticalSpace(8.h),
          _buildMenuItem(ImageAsset.settingIcon, 'Settings'),
          _buildMenuItem(ImageAsset.helpIcon, 'Help Center'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String svgPath, // بدل IconData
    String title, {
    bool isSelected = false,
    int badgeCount = 0,
  }) {
    return Container(
      height: 44.h,
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.blackColor17 : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: isSelected
            ? Border.all(color: AppColors.primaryColor, width: 3)
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              height: 20.sp,
              width: 20.sp,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            horizontalSpace(12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
            if (badgeCount > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFCEFF33),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
