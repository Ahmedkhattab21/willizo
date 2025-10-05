import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 46.r,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 16.r,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Mohamed Seyam',
          style: TextStyles.font22WhiteColorW600.copyWith(fontSize: 18.sp),
        ),
        const SizedBox(height: 6),
        Text(
          'mh16998866@gmail.com',
          style: TextStyles.font14whiteColorColorW400.copyWith(fontSize: 10.sp),
        ),
      ],
    );
  }
}
