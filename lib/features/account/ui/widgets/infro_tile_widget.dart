import 'package:flutter/material.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const InfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.font12BlackColorColorW500.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
          verticalSpace(6),
          Text(
            value,
            style: TextStyles.font14BlackColorW700.copyWith(
              color: AppColors.greenColor5e6,
            ),
          ),
        ],
      ),
    );
  }
}
