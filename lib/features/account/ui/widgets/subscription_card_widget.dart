import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class SubscriptionCard extends StatefulWidget {
  const SubscriptionCard({super.key});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard>
    with SingleTickerProviderStateMixin {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subscription',
                style: TextStyles.font14whiteColorColorW400.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SvgPicture.asset(ImageAsset.editIcon, width: 20.w, height: 20.h),
            ],
          ),
          verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan',
                      style: TextStyles.font14whiteColorColorW400.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    verticalSpace(6),
                    Text(
                      'Premium, Family',
                      style: TextStyles.font14whiteColorColorW400.copyWith(
                        color: AppColors.greenColor5e6,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Family',
                      style: TextStyles.font14whiteColorColorW400.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '2 members',
                      style: TextStyles.font14whiteColorColorW400.copyWith(
                        color: AppColors.greenColor5e6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(14),
          Stack(
            alignment: Alignment.bottomLeft,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -16,
                right: -16,
                child: Container(height: 1, color: AppColors.greyColor4d),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selected = 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analytics',
                          style: TextStyle(
                            color: _selected == 0
                                ? AppColors.primaryColor
                                : Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 70,
                          height: 4,
                          decoration: BoxDecoration(
                            color: _selected == 0
                                ? AppColors.primaryColor
                                : Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalSpace(22),
                  GestureDetector(
                    onTap: () => setState(() => _selected = 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            color: _selected == 1
                                ? AppColors.primaryColor
                                : AppColors.greyColorColor79,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 70,
                          height: 4,
                          decoration: BoxDecoration(
                            color: _selected == 1
                                ? AppColors.primaryColor
                                : Color(0xffd3d3d3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
