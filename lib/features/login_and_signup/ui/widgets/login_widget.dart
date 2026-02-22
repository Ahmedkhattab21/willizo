import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/app_text_field.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/login_and_signup/logic/login_and_signup_cubit.dart';
import 'package:willizo/features/login_and_signup/logic/login_and_signup_state.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        verticalSpace(24),

        AppTextFormField(
          hintText: "Email Address",
          hintStyle: TextStyles.font14greyColorColorW400,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 20.w,
          ),
          textStyle: TextStyles.font14whiteColorColorW400,
          controller: LoginAndSignup.get(context).loginEmailController,
          backgroundColor: AppColors.blackColor,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: SvgPicture.asset(ImageAsset.emailIcon),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.redColor, width: 2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.redColor, width: 2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Enter Value";
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        verticalSpace(20),

        AppTextFormField(
          hintText: "Password",
          hintStyle: TextStyles.font14greyColorColorW400,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 20.w,
          ),
          textStyle: TextStyles.font14whiteColorColorW400,
          controller: LoginAndSignup.get(context).loginPasswordController,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: SvgPicture.asset(ImageAsset.passwordIcon),
          ),
          backgroundColor: AppColors.blackColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.redColor, width: 2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.redColor, width: 2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Enter Value";
            }
            return null;
          },
          keyboardType: TextInputType.visiblePassword,
        ),
        verticalSpace(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                context.pushNamed(Routes.forgetPasswordScreen);
              },
              child: Text(
                "Forgot password?",
                style: TextStyles.font14primaryColorW400,
              ),
            ),
          ],
        ),
        verticalSpace(24),
        BlocConsumer<LoginAndSignup, LoginAndSignupState>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              AppConstant.toast("Login successfully", AppColors.primaryColor);
              context.pushNamed(Routes.buttonNavBarWidget);
            } else if (state is LoginFailureState) {
              AppConstant.toast(state.error, AppColors.redColor);
            }
          },
          builder: (context, state) {
            return ButtonWidget(
              isLoading: state is LoginLoadingState,
              borderRadius: 10,
              buttonHeight: 46.h,
              buttonText: "Sign in",
              backGroundColor: AppColors.primaryColor,
              borderColor: AppColors.primaryColor,
              textStyle: TextStyles.font18blackColorW600,
              onPressed: () {
                if (LoginAndSignup.get(
                  context,
                ).loginKey.currentState!.validate()) {
                  LoginAndSignup.get(context).login();
                }
              },
            );
          },
        ),
        verticalSpace(24),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(color: AppColors.whiteColor),
              ),
            ),
            horizontalSpace(20),
            Text(
              'or continue with',
              style: TextStyles.font14greyColorColor80W400,
            ),
            horizontalSpace(20),
            Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(color: AppColors.whiteColor),
              ),
            ),
          ],
        ),
        verticalSpace(24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 40.r,
              width: 40.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.greyColorColorDF,
              ),
              child: SvgPicture.asset(ImageAsset.googleIcon),
            ),
            Container(
              height: 40.r,
              width: 40.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.greyColorColorDF,
              ),
              child: SvgPicture.asset(ImageAsset.appleIcon),
            ),
            Container(
              height: 40.r,
              width: 40.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.greyColorColorDF,
              ),
              child: SvgPicture.asset(ImageAsset.facebookIcon),
            ),
          ],
        ),

        verticalSpace(32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account?\t',
              style: TextStyles.font14greyColorColorA0W400,
            ),
            GestureDetector(
              onTap: () {
                LoginAndSignup.get(context).changeSignInState(2);
              },
              child: Text(
                '\t Sign Up',
                style: TextStyles.font14primaryColorW600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
