import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';

class TopFollowerCardWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String followersCount;

  const TopFollowerCardWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.followersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyColor2727,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 36.r, backgroundImage: NetworkImage(imageUrl)),
          verticalSpace(12),
          Text(
            name,
            style: TextStyles.font14whiteColorColorW400,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpace(4),
          Text(
            followersCount,
            style: TextStyles.font12whiteColorColorW400.copyWith(
              color: AppColors.greyColorD1,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpace(16),
          ButtonWidget(
            isLoading: false,
            onPressed: () {},
            buttonText: "Follow",
            backGroundColor: AppColors.primaryColor,
            fourGroundColor: AppColors.blackColor,
            buttonHeight: 32.h,
            borderRadius: 24,
            textStyle: TextStyles.font14BlackColorW700.copyWith(
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
