import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/forget_password_done/logic/forget_password_done_cubit.dart';
import 'package:willizo/features/forget_password_done/logic/forget_password_done_state.dart';

class ForgetPasswordDoneScreen extends StatelessWidget {
  const ForgetPasswordDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                          text: 'Password ',
                          style: TextStyles.font24W600.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Reset',
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
              Text(
                'Your password has been successfully reset. click confirm to set a new password',
                style: TextStyles.font12whiteColorColorW400.copyWith(
                  color: AppColors.whiteColor.withValues(alpha: .7),
                ),
              ),
              verticalSpace(32),
              BlocConsumer<ForgetPasswordDoneCubit, ForgetPasswordDoneState>(
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
                    buttonText: "Reset Password",
                    backGroundColor: AppColors.primaryColor,
                    borderColor: AppColors.primaryColor,
                    textStyle: TextStyles.font18blackColorW600,
                    onPressed: () {
                      context.pushNamed(Routes.createNewPasswordScreen);
                    },
                  );
                },
              ),
            ],
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
