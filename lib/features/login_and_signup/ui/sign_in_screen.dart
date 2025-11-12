import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/login_and_signup/logic/login_and_signup_cubit.dart';
import 'package:willizo/features/login_and_signup/logic/login_and_signup_state.dart';
import 'package:willizo/features/login_and_signup/ui/widgets/login_widget.dart';
import 'package:willizo/features/login_and_signup/ui/widgets/register_widget.dart';
import 'package:willizo/features/login_and_signup/ui/widgets/taps_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LoginAndSignup, LoginAndSignupState>(
          buildWhen: (previous, current) {
            return current is OnChangeSignInState;
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Form(
                key: LoginAndSignup.get(context).signInState == 1
                    ? LoginAndSignup.get(context).loginKey
                    : LoginAndSignup.get(context).registerKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    verticalSpace(80),
                    Image.asset(ImageAsset.appLogoImage),
                    if (LoginAndSignup.get(context).signInState == 2)
                      verticalSpace(12),
                    if (LoginAndSignup.get(context).signInState == 2)
                      Text(
                        'Create your account to start your fitness journey',
                        style: TextStyles.font14greyColorColorEDW400,
                      ),
                    if (LoginAndSignup.get(context).signInState == 2)
                      verticalSpace(30),
                    if (LoginAndSignup.get(context).signInState == 1)
                      verticalSpace(50),
                    TapsWidget(),
                    if (LoginAndSignup.get(context).signInState == 1)
                      LoginWidget(),
                    if (LoginAndSignup.get(context).signInState == 2)
                      RegisterWidget(),

                    // verticalSpace(16),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "Already have an account? ",
                    //       style: TextStyles.font16BlackColorBold,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         context.pushNamed(Routes.loginScreen);
                    //       },
                    //       child: Text(
                    //         "Sign In",
                    //         style: TextStyles.font16BlackColorBold.copyWith(
                    //           color: AppColors.redColor,
                    //           fontWeight: FontWeight.bold,
                    //           decoration: TextDecoration.underline,
                    //           decorationColor: AppColors.redColor,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    verticalSpace(40),
                  ],
                ),
              ),
            );
          },
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
