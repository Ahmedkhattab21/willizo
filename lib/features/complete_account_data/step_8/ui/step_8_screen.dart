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
import 'package:willizo/features/complete_account_data/step_8/logic/step_8_cubit.dart';
import 'package:willizo/features/complete_account_data/step_8/logic/step_8_state.dart';

class Step8Screen extends StatelessWidget {
  const Step8Screen({super.key});

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
                              text: 'Goals ',
                              style: TextStyles.font12W700.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            TextSpan(
                              text: '/ Plans',
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
                        percent: 8 / 21,
                        center: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '8 ',
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
                      text: 'How many   ',
                      style: TextStyles.font24w600.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                    TextSpan(
                      text: 'days ',
                      style: TextStyles.font24w600.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),

                    TextSpan(
                      text: 'a week can you workout ?',
                      style: TextStyles.font24w600.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(24),

            BlocBuilder<Step8Cubit, Step8State>(
              buildWhen: (previous, current) {
                return current is OnChangeSelectedState;
              },
              builder: (context, state) {
                return Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: Step8Cubit.get(context).items
                          .map(
                            (item) => GestureDetector(
                              onTap: () {
                                Step8Cubit.get(context).addOrDeleteItem(item);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.w,
                                ),
                                margin: EdgeInsets.symmetric(vertical: 4.w),
                                decoration: BoxDecoration(
                                  color: AppColors.greyColorColor00,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color:
                                        Step8Cubit.get(
                                          context,
                                        ).containItem(item)
                                        ? AppColors.primaryColor
                                        : AppColors.greyColorColor00,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  item.name,
                                  style:
                                      Step8Cubit.get(context).containItem(item)
                                      ? TextStyles.font16primaryColorW600
                                      : TextStyles.font16WhiteColorW600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
            // verticalSpace(24),
            verticalSpace(8),
            BlocConsumer<Step8Cubit, Step8State>(
              // buildWhen: (previous, current) {
              //   return current is OnRegisterLoadingState ||
              //       current is OnRegisterSuccessState ||
              //       current is OnRegisterErrorState ||
              //       current is OnRegisterCatchErrorState;
              // },
              listener: (context, state) {
                if (state is Step8SuccessState) {
                  context.pushNamed(Routes.step9Screen);
                } else if (state is Step8ErrorState) {
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
                    isLoading: state is Step8LoadingState,
                    borderRadius: 50,
                    buttonHeight: 46.h,
                    buttonText: "Next",
                    backGroundColor: AppColors.primaryColor,
                    borderColor: AppColors.primaryColor,
                    textStyle: TextStyles.font18blackColorW600,
                    onPressed: () {
                      final cubit = Step8Cubit.get(context);
                      if (cubit.isValid) {
                        cubit.sendStep();
                      } else {
                        AppConstant.toast(
                          "Please select at least one day",
                          AppColors.redColor,
                        );
                      }
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
