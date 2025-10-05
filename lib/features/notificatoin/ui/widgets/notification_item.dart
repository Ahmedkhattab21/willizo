import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String timeAgo;
  final String body;
  final String avatarUrl;
  const NotificationItem({
    super.key,
    required this.title,
    required this.timeAgo,
    required this.body,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blackColor1E,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .6),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: CircleAvatar(
                  radius: 16.r,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),

              horizontalSpace(12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 10.sp,
                      children: [
                        Text(
                          title,
                          style: TextStyles.font14whiteColorColorW400,
                        ),

                        Text(
                          timeAgo,
                          style: TextStyles.font12BlackColorColorW500.copyWith(
                            color: AppColors.greyColorColor79,
                          ),
                        ),
                      ],
                    ),

                    verticalSpace(8),

                    Text(
                      body,
                      style: TextStyles.font12BlackColorColorW500.copyWith(
                        color: AppColors.greyColorColor79,
                      ),
                    ),
                    verticalSpace(12),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Dismiss',
                            style: TextStyles.font12W700.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),

                        horizontalSpace(18),

                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Accept',
                            style: TextStyles.font14PrimaryColorW600.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          verticalSpace(12),
        ],
      ),
    );
  }
}
