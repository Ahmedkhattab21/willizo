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
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/widgets/app_text_field.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/complete_account_data/step_2/logic/step_2_cubit.dart';
import 'package:willizo/features/complete_account_data/step_2/logic/step_2_state.dart';

class Step2Screen extends StatelessWidget {
  const Step2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Form(
          key: Step2Cubit.get(context).key,
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
                          percent: 2 / 21,
                          center: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '2 ',
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
                        text: 'age ',
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
                child: AppTextFormField(
                  hintText: "Your Age",
                  hintStyle: TextStyles.font14greyColorColorW400,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 20.w,
                  ),
                  textStyle: TextStyles.font14whiteColorColorW400,
                  controller: Step2Cubit.get(context).ageController,

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
                  keyboardType: TextInputType.number,
                ),
              ),

              Spacer(),
              BlocConsumer<Step2Cubit, Step2State>(
                listener: (context, state) {
                  if (state is Step2SuccessState) {
                    context.pushNamed(Routes.step3Screen);
                  } else if (state is Step2ErrorState) {
                    AppConstant.toast(state.message, AppColors.redColor);
                  }
                },
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.greyColorColor00,
                    ),
                    padding: EdgeInsets.only(
                      left: 18.w,
                      right: 18.w,
                      top: 20.h,
                      bottom: 34.h,
                    ),
                    child: ButtonWidget(
                      isLoading: state is Step2LoadingState,
                      borderRadius: 50,
                      buttonHeight: 46.h,
                      buttonText: "Next",
                      backGroundColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      textStyle: TextStyles.font18blackColorW600,
                      onPressed: () {
                        if (Step2Cubit.get(
                          context,
                        ).key.currentState!.validate()) {
                          Step2Cubit.get(context).sendStep();
                        }
                      },
                    ),
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
