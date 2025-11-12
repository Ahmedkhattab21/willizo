import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/login_and_signup/logic/login_and_signup_cubit.dart';

class TapsWidget extends StatelessWidget {
  const TapsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.blackColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                LoginAndSignup.get(context).changeSignInState(1);
              },
              child: Container(
                height: 30.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: LoginAndSignup.get(context).signInState == 1
                      ? AppColors.primaryColor
                      : Colors.transparent,
                ),
                child: Text(
                  'Sign in',
                  style: TextStyles.font14BlackColorW700.copyWith(
                    color: LoginAndSignup.get(context).signInState == 1
                        ? AppColors.blackColor
                        : AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          horizontalSpace(6),
          Expanded(
            child: GestureDetector(
              onTap: () {
                LoginAndSignup.get(context).changeSignInState(2);
              },
              child: Container(
                height: 30.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: LoginAndSignup.get(context).signInState == 2
                      ? AppColors.primaryColor
                      : Colors.transparent,
                ),
                child: Text(
                  'Sign up',
                  style: TextStyles.font14BlackColorW700.copyWith(
                    color: LoginAndSignup.get(context).signInState == 2
                        ? AppColors.blackColor
                        : AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
