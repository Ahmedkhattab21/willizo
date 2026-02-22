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

  const FriendInfoCardWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.activeStatus,
    this.isActiveNow = false,
  });

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
                backgroundImage: NetworkImage(imageUrl),
              ),
              if (isActiveNow)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: AppColors.greenColor12,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.blackColor,
                        width: 2.w,
                      ),
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
              ],
            ),
          ),
          Container(
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
        ],
      ),
    );
  }
}
