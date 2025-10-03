import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/app_text_field.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/complete_account_data/step_5/logic/step_5_cubit.dart';
import 'package:willizo/features/complete_account_data/step_5/logic/step_5_state.dart';

class Step5Screen extends StatelessWidget {
  const Step5Screen({super.key});

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
                              text: 'personal ',
                              style: TextStyles.font12W700.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Data',
                              style: TextStyles.font12W700.copyWith(
                                color: AppColors.primaryColor,
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
                        percent: 5 / 21,
                        center: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '5 ',
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
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'What’s your ',
                      style: TextStyles.font24w600.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                    TextSpan(
                      text: 'weight ',
                      style: TextStyles.font24w600.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: '?',
                      style: TextStyles.font24w600.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(34),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.primaryColor),
                    ),
                    child: Text(
                      'Kilos',
                      style: TextStyles.font16White2ColorW600,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(34),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  horizontalSpace(14),
                  Expanded(
                    child: BlocBuilder<Step5Cubit, Step5State>(
                      buildWhen: (previous, current) {
                        return current is OnChangeSelectedKiloState;
                      },
                      builder: (context, state) {
                        return SizedBox(
                          height: 250.h,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 95.h,
                            perspective: 0.003,
                            diameterRatio: 3.0,
                            overAndUnderCenterOpacity: .4,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              Step5Cubit.get(
                                context,
                              ).onChangeSelectedKilo(index);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                if (index > 990) return null; // stop at 250 cm
                                return Center(
                                  child: Column(
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '$index \t',
                                              style: TextStyles
                                                  .font40WhiteColorBold,
                                            ),
                                            TextSpan(
                                              text: 'Kilos',
                                              style: TextStyles
                                                  .font40WhiteColorBold
                                                  .copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(color: AppColors.primaryColor),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  horizontalSpace(25),
                  Text('.', style: TextStyles.font40WhiteColorBold),
                  horizontalSpace(25),
                  Expanded(
                    child: BlocBuilder<Step5Cubit, Step5State>(
                      buildWhen: (previous, current) {
                        return current is OnChangeSelectedKiloState;
                      },
                      builder: (context, state) {
                        return SizedBox(
                          height: 250.h,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 95.h,
                            perspective: 0.003,
                            diameterRatio: 3.0,
                            overAndUnderCenterOpacity: .4,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              Step5Cubit.get(
                                context,
                              ).onChangeSelectedGram(index);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                if (index > 990) return null; // stop at 250 cm
                                return Center(
                                  child: Column(
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '$index \t',
                                              style: TextStyles
                                                  .font40WhiteColorBold,
                                            ),
                                            TextSpan(
                                              text: 'g',
                                              style: TextStyles
                                                  .font40WhiteColorBold
                                                  .copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(color: AppColors.primaryColor),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  horizontalSpace(14),
                ],
              ),
            ),
            verticalSpace(6),

            Spacer(),
            BlocConsumer<Step5Cubit, Step5State>(
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
                      context.pushNamed(Routes.step6Screen);
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
