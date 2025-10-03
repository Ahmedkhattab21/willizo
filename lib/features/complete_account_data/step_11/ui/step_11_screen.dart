import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/complete_account_data/step_11/logic/step_11_state.dart';
import 'package:willizo/features/complete_account_data/step_11/logic/step_11_cubit.dart';

class Step11Screen extends StatelessWidget {
  const Step11Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            verticalSpace(16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
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
                  Spacer(flex: 2),
                  Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Activity ',
                              style: TextStyles.font12W700.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            TextSpan(
                              text: '/ Health ',
                              style: TextStyles.font12W700.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpace(12),
                      CircularPercentIndicator(
                        radius: 45.r,
                        lineWidth: 7.r,
                        backgroundColor: AppColors.greyColorColor79,
                        progressColor: AppColors.primaryColor,
                        percent: 11 / 21,
                        center: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '11 ',
                                style: TextStyles.font14W700.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              TextSpan(
                                text: '/ 21',
                                style: TextStyles.font14W700.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(flex: 3),
                ],
              ),
            ),
            verticalSpace(24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'How ',
                      style: TextStyles.font24w600.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                    TextSpan(
                      text: 'active ',
                      style: TextStyles.font24w600.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: 'are you? ',
                      style: TextStyles.font24w600.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(24),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Please select only one option below.",
                    style: TextStyles.font14greyColorColor79W400,
                  ),
                ],
              ),
            ),
            verticalSpace(8),

            BlocBuilder<Step11Cubit, Step11State>(
              buildWhen: (previous, current) {
                return current is OnChangeSelectedState;
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: Step11Cubit.get(context).activeItems
                        .map(
                          (item) => GestureDetector(
                            onTap: () {
                              Step11Cubit.get(
                                context,
                              ).changeSelectedWeightId(item.id);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.w,
                              ),
                              margin: EdgeInsets.symmetric(vertical: 6.w),
                              decoration: BoxDecoration(
                                color: AppColors.greyColorColor00,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color:
                                      Step11Cubit.get(
                                            context,
                                          ).selectedWeightId ==
                                          item.id
                                      ? AppColors.primaryColor
                                      : AppColors.greyColorColor00,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                item.name,
                                style:
                                    Step11Cubit.get(context).selectedWeightId ==
                                        item.id
                                    ? TextStyles.font16primaryColorW600
                                    : TextStyles.font16WhiteColorW600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),

            Spacer(),
            BlocConsumer<Step11Cubit, Step11State>(
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
                return Container(
                  decoration: BoxDecoration(color: AppColors.greyColorColor00),
                  padding: EdgeInsets.only(
                    left: 18.w,
                    right: 18.w,
                    top: 20.h,
                    bottom: 34.h,
                  ),
                  child: ButtonWidget(
                    isLoading: false,
                    borderRadius: 50,
                    buttonHeight: 46.h,
                    buttonText: "Next",
                    backGroundColor: AppColors.primaryColor,
                    borderColor: AppColors.primaryColor,
                    textStyle: TextStyles.font18blackColorW600,
                    onPressed: () {
                      context.pushNamed(Routes.step12Screen);
                      // validateRegister(context);
                    },
                  ),
                );
              },
            ),
          ],
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
