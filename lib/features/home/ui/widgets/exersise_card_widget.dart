import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.kCardGreenStart, AppColors.kCardGreenEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.kCardGreenStart.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(70),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: 48,
                      height: 48,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,

                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        ImageAsset.muscleIcon,
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXERCISES',
                          style: TextStyles.font16BlackColorW400.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          'Do biceps exercise',
                          style: TextStyles.font12BlackColorColorW500,
                        ),
                        verticalSpace(8),
                      ],
                    ),
                  ),
                  // menu
                  const SizedBox(width: 8),
                  Column(
                    children: const [
                      Icon(Icons.more_vert, color: Colors.black54),
                    ],
                  ),
                ],
              ),

              Text(
                'The biceps curl is a basic strength training exercise that targets.',
                style: TextStyles.font12W700.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.7,
                ),
              ),
              verticalSpace(14),
              Row(
                children: [
                  ButtonWidget(
                    isLoading: false,
                    buttonText: "Start",
                    textStyle: TextStyles.font14PrimaryColorW600,
                    icon: Icons.arrow_forward,
                    iconColor: AppColors.primaryColor,
                    backGroundColor: Colors.black,
                    borderRadius: 40,
                    buttonWidth: 94.w,
                    buttonHeight: 41.h,
                    horizontalPadding: 18.w,
                    verticalPadding: 10.h,
                    onPressed: () {},
                  ),

                  horizontalSpace(12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.08),
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 18.r,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '50 Min',
                          style: TextStyles.font14BlackColorW700.copyWith(
                            fontWeight: FontWeight.w600,
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
