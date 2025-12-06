import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/core/widgets/card_widget.dart';
import 'package:willizo/features/complete_account_data/step_19/logic/step_19_cubit.dart';
import 'package:willizo/features/complete_account_data/step_19/logic/step_19_state.dart';

class Step19Screen extends StatefulWidget {
  const Step19Screen({super.key});

  @override
  State<Step19Screen> createState() => _Step19ScreenState();
}

class _Step19ScreenState extends State<Step19Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Step19Cubit.get(context).getFreeWeights();
    });
  }

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
                              text: 'Equipments ',
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
                        percent: 19 / 21,
                        center: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '19 ',
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
            BlocBuilder<Step19Cubit, Step19State>(
              buildWhen: (previous, current) {
                return current is OnChangeSelectedState ||
                    current is GetFreeWeightsSuccess;
              },
              builder: (context, state) {
                final cubit = Step19Cubit.get(context);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Free weights",
                            style: TextStyles.font14W600.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              cubit.selectAllWeights();
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  cubit.isAllSelected
                                      ? ImageAsset.selectAllIcon
                                      : ImageAsset.selectIcon,
                                ),
                                horizontalSpace(10),
                                Text(
                                  "Select All",
                                  style: TextStyles.font12WhiteColorW500.copyWith(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            verticalSpace(10),
            Expanded(
              child: BlocBuilder<Step19Cubit, Step19State>(
                buildWhen: (previous, current) {
                  return current is GetFreeWeightsLoading ||
                      current is GetFreeWeightsSuccess ||
                      current is GetFreeWeightsError ||
                      current is OnChangeSelectedState;
                },
                builder: (context, state) {
                  final cubit = Step19Cubit.get(context);
                  
                  if (state is GetFreeWeightsLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }
                  
                  if (state is GetFreeWeightsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyles.font14W600.copyWith(
                          color: AppColors.redColor,
                        ),
                      ),
                    );
                  }
                  
                  if (cubit.freeWeights.isEmpty) {
                    return Center(
                      child: Text(
                        "No weights available",
                        style: TextStyles.font14W600.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    );
                  }
                  
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: cubit.freeWeights.length,
                      itemBuilder: (context, index) {
                        final weight = cubit.freeWeights[index];
                        final isSelected = cubit.isWeightSelected(weight);
                        return GymMachineCard(
                          imageUrl: weight.imageUrl,
                          title: weight.name,
                          description: weight.description,
                          isSelected: isSelected,
                          onTap: () {
                            cubit.toggleWeight(weight);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            BlocConsumer<Step19Cubit, Step19State>(
              // buildWhen: (previous, current) {
              //   return current is OnRegisterLoadingState ||
              //       current is OnRegisterSuccessState ||
              //       current is OnRegisterErrorState ||
              //       current is OnRegisterCatchErrorState;
              // },
              listener: (context, state) {
                if (state is Step19SuccessState) {
                  context.pushNamed(Routes.step20Screen);
                } else if (state is Step19ErrorState) {
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
                    isLoading: state is Step19LoadingState,
                    borderRadius: 50,
                    buttonHeight: 46.h,
                    buttonText: "Next",
                    backGroundColor: AppColors.primaryColor,
                    borderColor: AppColors.primaryColor,
                    textStyle: TextStyles.font18blackColorW600,
                    onPressed: () {
                      final cubit = Step19Cubit.get(context);
                      if (cubit.isValid) {
                        cubit.sendStep();
                      } else {
                        AppConstant.toast("Please select at least one free weight", AppColors.redColor);
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
