import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/complete_account_data/step_3/logic/step_3_cubit.dart';
import 'package:willizo/features/complete_account_data/step_3/logic/step_3_state.dart';

class Step3Screen extends StatelessWidget {
  const Step3Screen({super.key});

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
                      context.clearAuthAndOpenSignIn();
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
                        percent: 3 / 21,
                        center: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '3 ',
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
                      text: 'gender ',
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
            verticalSpace(6),

            BlocBuilder<Step3Cubit, Step3State>(
              buildWhen: (previous, current) {
                return current is OnChangeSelectedState;
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: Step3Cubit.get(context).genders
                        .map(
                          (item) => GestureDetector(
                            onTap: () {
                              Step3Cubit.get(
                                context,
                              ).changeSelectedGender(item.id);
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
                                      Step3Cubit.get(context).selectedGender ==
                                          item.id
                                      ? AppColors.primaryColor
                                      : AppColors.greyColorColor00,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                item.name,
                                style:
                                    Step3Cubit.get(context).selectedGender ==
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
            BlocConsumer<Step3Cubit, Step3State>(
              listener: (context, state) {
                if (state is Step3SuccessState) {
                  context.pushNamed(Routes.step4Screen);
                } else if (state is Step3ErrorState) {
                  AppConstant.toast(state.message, AppColors.redColor);
                }
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
                    isLoading: state is Step3LoadingState,
                    borderRadius: 50,
                    buttonHeight: 46.h,
                    buttonText: "Next",
                    backGroundColor: AppColors.primaryColor,
                    borderColor: AppColors.primaryColor,
                    textStyle: TextStyles.font18blackColorW600,
                    onPressed: () {
                      Step3Cubit.get(context).sendStep();
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
