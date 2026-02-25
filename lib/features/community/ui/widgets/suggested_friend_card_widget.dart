import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';

class SuggestedFriendCardWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String? distance;
  final String subtitle;

  const SuggestedFriendCardWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    this.distance,
    required this.subtitle,
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
          CircleAvatar(
            radius: 28.r,
            child: Icon(Icons.person, size: 28.r),
          ),

          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyles.font16WhiteColorW600.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                    if (distance != null) ...[
                      horizontalSpace(8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greenColorDC,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          distance!,
                          style: TextStyles.font12InterW400.copyWith(
                            color: AppColors.greenColor1665,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                verticalSpace(4),
                Text(
                  subtitle,
                  style: TextStyles.font14greyColorColor79W400.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          ButtonWidget(
            isLoading: false,
            onPressed: () {},
            buttonText: "Add",
            buttonWidth:
                64, // Providing a defined width makes it not overflow row bounds
            buttonHeight: 32.h,
            backGroundColor: AppColors.primaryColor,
            fourGroundColor: AppColors.blackColor,
            borderRadius: 20,
            horizontalPadding: 4,
            verticalPadding: 4,
            textStyle: TextStyles.font14BlackColorW700.copyWith(
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
