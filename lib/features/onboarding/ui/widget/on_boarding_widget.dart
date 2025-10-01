import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/onboarding/logic/onboarding_cubit.dart';

class OnBoardingWidget extends StatelessWidget {
  int page;
  OnBoardingWidget({required this.page, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(20),
        if (page != 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  context.pushNamed(Routes.signInScreen);
                },
                child: Text('Skip', style: TextStyles.font16PrimaryColorW400),
              ),
            ],
          ),
        Spacer(),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: page == 1
                    ? 'NO MORE EXCUSES | \n'
                    : page == 2
                    ? 'Boost Success with | \n'
                    : 'Join Our Lively Gym | \n',
                style: TextStyles.font40WhiteColorW400,
              ),

              TextSpan(
                text: page == 1
                    ? 'DO IT NOW'
                    : page == 2
                    ? 'A Strong Diet'
                    : 'Rise in Ranks!',
                style: TextStyles.font40PrimaryColorW400,
              ),
            ],
          ),
        ),
        verticalSpace(12),
        Text(
          page == 1
              ? 'Achieve your fitness goals with our expert trainers! Join us for personalized workouts that get results'
              : page == 2
              ? 'Our app provides a concise dietary system to boost fitness goals, with balanced plans rich in proteins and vitamins.'
              : 'Our app provides a lively community system for participation and a dynamic rank feature to highlight your gym achievements and progress.',
          style: TextStyles.font16WhiteColorW400,
        ),
        verticalSpace(50),
        Row(
          children: [
            page == 1
                ? Container(
                    height: 10.r,
                    width: 36.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 10.r,
                          width: 10.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 10.r,
                    width: 10.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                  ),

            horizontalSpace(4),
            page == 2
                ? Container(
                    height: 10.r,
                    width: 40.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 10.r,
                          width: 10.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blackColor,
                          ),
                        ),
                        Container(
                          height: 10.r,
                          width: 10.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 10.r,
                    width: 10.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                  ),
            horizontalSpace(4),
            page == 3
                ? Container(
                    height: 10.r,
                    width: 36.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 10.r,
                          width: 10.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 10.r,
                    width: 10.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                  ),
            Spacer(),
            GestureDetector(
              onTap: () {
                if (page == 3) {
                  context.pushNamed(Routes.signInScreen);
                } else {
                  OnboardingCubit.get(context).changeOnBoardingPage(page + 1);
                }
              },
              child: Container(
                height: 62.r,
                width: 62.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.blackColor,
                  size: 20.r,
                ),
              ),
            ),
            verticalSpace(100),
          ],
        ),
      ],
    );
  }
}
