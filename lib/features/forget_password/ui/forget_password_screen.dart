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
import 'package:willizo/features/forget_password/logic/forget_password_cubit.dart';
import 'package:willizo/features/forget_password/logic/forget_password_state.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: ForgetPasswordCubit.get(context).forgetKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        height: 30.r,
                        width: 30.r,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(40),
                Image.asset(ImageAsset.appLogoImage),
                verticalSpace(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Forget',
                            style: TextStyles.font24W600.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          TextSpan(
                            text: ' password',
                            style: TextStyles.font24W600.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                verticalSpace(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please enter your email to reset the password',
                      style: TextStyles.font12whiteColorColorW400.copyWith(
                        color: AppColors.whiteColor.withValues(alpha: .7),
                      ),
                    ),
                  ],
                ),
                verticalSpace(32),
                AppTextFormField(
                  hintText: "Email Address",
                  hintStyle: TextStyles.font14greyColorColorW400,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 20.w,
                  ),
                  textStyle: TextStyles.font14whiteColorColorW400,
                  controller: ForgetPasswordCubit.get(context).emailController,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    child: SvgPicture.asset(ImageAsset.emailIcon),
                  ),
                  backgroundColor: AppColors.blackColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
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
                verticalSpace(32),
                BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                  listener: (context, state) {
                    if (state is ForgetPasswordSuccessState) {
                      AppConstant.toast(
                        "Reset code sent successfully",
                        AppColors.primaryColor,
                      );
                      context.pushNamed(
                        Routes.forgetPasswordCodeScreen,
                        arguments: {
                          'email': ForgetPasswordCubit.get(context).emailController.text,
                        },
                      );
                    } else if (state is ForgetPasswordErrorState) {
                      AppConstant.toast(state.error, AppColors.redColor);
                    }
                  },
                  builder: (context, state) {
                    return ButtonWidget(
                      isLoading: state is ForgetPasswordLoadingState,
                      borderRadius: 10,
                      buttonHeight: 46.h,
                      buttonText: "Reset Password",
                      backGroundColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      textStyle: TextStyles.font18blackColorW600,
                      onPressed: () {
                        if (ForgetPasswordCubit.get(context).forgetKey.currentState!.validate()) {
                          ForgetPasswordCubit.get(context).forgetPassword();
                        }
                      },
                    );
                  },
                ),
                verticalSpace(32),
                Text(
                  'Try with Phone Number',
                  style: TextStyles.font12whiteColorColorW400.copyWith(
                    decorationColor: AppColors.whiteColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void validateRegister(BuildContext context) {
  //   if (RegisterCubit.get(context).registerKey.currentState!.validate()) {
  //     RegisterCubit.get(context).sign_in();
  //   }
  // }
}
