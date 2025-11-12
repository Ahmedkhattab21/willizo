import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/app_text_field.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/login_and_signup/logic/login_and_signup_cubit.dart';
import 'package:willizo/features/login_and_signup/logic/login_and_signup_state.dart';

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        verticalSpace(24),

        AppTextFormField(
          hintText: "Full Name",
          hintStyle: TextStyles.font14greyColorColorW400,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 20.w,
          ),
          textStyle: TextStyles.font14whiteColorColorW400,
          controller: LoginAndSignup.get(context).registerNameController,
          backgroundColor: AppColors.blackColor,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: SvgPicture.asset(ImageAsset.nameIcon),
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
          keyboardType: TextInputType.name,
        ),
        verticalSpace(20),
        AppTextFormField(
          hintText: "Phone Number",
          hintStyle: TextStyles.font14greyColorColorW400,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 20.w,
          ),
          textStyle: TextStyles.font14whiteColorColorW400,
          controller: LoginAndSignup.get(context).registerPhoneController,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: SvgPicture.asset(ImageAsset.phoneIcon),
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
          keyboardType: TextInputType.phone,
        ),
        verticalSpace(20),
        AppTextFormField(
          hintText: "Email Address",
          hintStyle: TextStyles.font14greyColorColorW400,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 20.w,
          ),
          textStyle: TextStyles.font14whiteColorColorW400,
          controller: LoginAndSignup.get(context).registerEmailController,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: SvgPicture.asset(ImageAsset.phoneIcon),
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
          keyboardType: TextInputType.emailAddress,
        ),
        verticalSpace(20),
        AppTextFormField(
          hintText: "Date of Birth",
          hintStyle: TextStyles.font14greyColorColorW400,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 20.w,
          ),
          textStyle: TextStyles.font14whiteColorColorW400,
          controller: LoginAndSignup.get(context).registerBirthDateController,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: SvgPicture.asset(ImageAsset.birthDateIcon),
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
          keyboardType: TextInputType.none,
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
          controller: LoginAndSignup.get(context).registerPasswordController,
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
        verticalSpace(24),
        BlocBuilder<LoginAndSignup, LoginAndSignupState>(
          buildWhen: (previous, current) {
            return current is OnChangeAgreeForTermsState;
          },
          builder: (context, state) {
            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    LoginAndSignup.get(context).changeAgreeForTerms();
                  },
                  child: SvgPicture.asset(
                    LoginAndSignup.get(context).isAgreeForTerms
                        ? ImageAsset.selectedBoxIcon
                        : ImageAsset.boxIcon,
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'I agree to the ',
                          style: TextStyles.font13primaryColorW400.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Terms of Service ',
                          style: TextStyles.font13primaryColorW400.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: 'and',
                          style: TextStyles.font13primaryColorW400
                            ..copyWith(color: AppColors.whiteColor),
                        ),
                        TextSpan(
                          text: ' Privacy Policy.',
                          style: TextStyles.font13primaryColorW400.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        verticalSpace(40),

        BlocConsumer<LoginAndSignup, LoginAndSignupState>(
          // buildWhen: (previous, current) {
          //   return current is OnRegisterLoadingState ||
          //       current is OnRegisterSuccessState ||
          //       current is OnRegisterErrorState ||
          //       current is OnRegisterCatchErrorState;
          // },
          listener: (context, state) {
            // if (state is OnRegisterSuccessState) {
            //   AppConstant.toast(
            //     "Register successfully. ",
            //     AppColors.greenColor,
            //   );
            //   if (state.accountStatus == 'pending') {
            //     ///
            //     context.pushNamed(Routes.registerDoneScreen);
            //   } else if (state.accountStatus ==
            //       'awaiting_verification') {
            //     context.pushNamed(
            //       Routes.registerOtpScreen,
            //       arguments: {
            //         'email': RegisterCubit.get(
            //           context,
            //         ).emailController.text,
            //       },
            //     );
            //   }
            // } else if (state is OnRegisterErrorState) {
            //   AppConstant.toast(state.message, AppColors.redColor);
            // } else if (state is OnRegisterCatchErrorState) {
            //   AppConstant.toast(
            //     "Something wrong tray again later!",
            //     AppColors.redColor,
            //   );
            // }
          },
          builder: (context, state) {
            return ButtonWidget(
              isLoading: false,
              borderRadius: 10,
              buttonHeight: 46.h,
              buttonText: "Sign up",
              backGroundColor: AppColors.primaryColor,
              borderColor: AppColors.primaryColor,
              textStyle: TextStyles.font18blackColorW600,
              onPressed: () {
                // validateRegister(context);
              },
            );
          },
        ),

        verticalSpace(32),
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
        verticalSpace(32),

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
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Already have an account? \t',
                style: TextStyles.font14greyColorColorA0W400,
              ),
              TextSpan(
                text: 'Sign In',
                style: TextStyles.font14primaryColorW600,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
