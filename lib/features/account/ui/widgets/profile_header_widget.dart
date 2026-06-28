import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 104.r,
                height: 104.r,
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.24),
                      blurRadius: 20.r,
                      spreadRadius: 1.r,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: AppColors.greyColor20,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                ),
              ),
              Positioned(
                right: -2.r,
                bottom: 4.r,
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.45),
                        blurRadius: 16.r,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 18.r,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(12),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyles.font22WhiteColorW600.copyWith(fontSize: 20.sp),
        ),
        verticalSpace(6),
        Text(
          email,
          textAlign: TextAlign.center,
          style: TextStyles.font14whiteColorColorW400.copyWith(
            color: AppColors.greyColorColorA0,
          ),
        ),
      ],
    );
  }
}
