import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class GymMachineCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final bool isSelected; 
  final VoidCallback? onTap;

  const GymMachineCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greyColorColor00,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              child: Image.network(
                imageUrl,
                height: 100.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100.h,
                    width: double.infinity,
                    color: AppColors.greyColorColor79,
                    child: Icon(
                      Icons.fitness_center,
                      color: AppColors.greyColorColor,
                      size: 40.r,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 100.h,
                    width: double.infinity,
                    color: AppColors.greyColorColor79,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.font14W600
                        .copyWith(color: AppColors.whiteColor),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyles.font12WhiteColorW500
                        .copyWith(color: AppColors.greyColorColor79),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
