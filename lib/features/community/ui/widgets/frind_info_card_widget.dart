import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/styles.dart';

class FriendInfoCardWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String activeStatus;
  final bool isActiveNow;
  final String? currentActivity;
  final VoidCallback? onRemoveTap;

  const FriendInfoCardWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.activeStatus,
    this.isActiveNow = false,
    this.currentActivity,
    this.onRemoveTap,
  });

  Widget _buildActivityRow(String activity) {
    String iconPath;
    Color iconColor;
    Color textColor;

    switch (activity.toLowerCase()) {
      case 'cardio':
        iconPath = ImageAsset.fire;
        iconColor = AppColors.orangeColorF6;
        textColor = AppColors.orangeColorF6;
        break;
      case 'yoga':
        iconPath = ImageAsset.fillHeartColorIcon;
        iconColor = Colors.transparent;
        textColor = AppColors.greyColor75;
        break;
      case 'running':
        iconPath = ImageAsset.runningIcon;
        iconColor = Colors.transparent;
        textColor = AppColors.greyColor75;
        break;
      case 'strength':
        iconPath = ImageAsset.worldCrownIcon;
        iconColor = AppColors.orangeColorF6;
        textColor = AppColors.orangeColorF6;
        break;
      default:
        return const SizedBox.shrink();
    }

    final String capitalizedActivity = activity.isNotEmpty
        ? '${activity[0].toUpperCase()}${activity.substring(1)}'
        : '';

    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 14.w,
            height: 14.h,
            colorFilter: iconColor != Colors.transparent
                ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                : null,
          ),
          SizedBox(width: 4.w),
          Text(
            capitalizedActivity,
            style: TextStyles.font10InterW400.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.greyColor3d, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.greyColor3d,
                child: Icon(
                  Icons.person,
                  color: AppColors.whiteColor,
                  size: 24.sp,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: isActiveNow
                        ? AppColors.greenColor12
                        : AppColors.greyColor2F,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.blackColor, width: 2.w),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyles.font14InterW600.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  activeStatus,
                  style: TextStyles.font10InterW400.copyWith(
                    color: AppColors.greyColor75,
                  ),
                ),
                if (currentActivity != null && currentActivity!.isNotEmpty)
                  _buildActivityRow(currentActivity!),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemoveTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.all(8.r),
              child: SvgPicture.asset(
                ImageAsset.removeFrindIcon,
                colorFilter: ColorFilter.mode(
                  AppColors.whiteColor,
                  BlendMode.srcIn,
                ),
                width: 17.w,
                height: 14.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
