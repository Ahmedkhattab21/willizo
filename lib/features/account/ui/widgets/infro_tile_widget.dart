import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const InfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.font12BlackColorColorW500.copyWith(
              color: AppColors.greyColorColor80,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font14BlackColorW700.copyWith(
              color: AppColors.whiteColorEb,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
