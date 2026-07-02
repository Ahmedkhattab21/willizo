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
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/core/widgets/card_widget.dart';
import 'package:willizo/features/complete_account_data/step_20/logic/step_20_cubit.dart';
import 'package:willizo/features/complete_account_data/step_20/logic/step_20_state.dart';

class Step20Screen extends StatefulWidget {
  const Step20Screen({super.key});

  @override
  State<Step20Screen> createState() => _Step20ScreenState();
}

class _Step20ScreenState extends State<Step20Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Step20Cubit.get(context).getSupportiveTools();
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
                      context.closeEditingStepOrOpenSignIn();
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
                        percent: 20 / 21,
                        center: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '20 ',
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
            BlocBuilder<Step20Cubit, Step20State>(
              buildWhen: (previous, current) {
                return current is OnChangeSelectedState ||
                    current is GetSupportiveToolsSuccess;
              },
              builder: (context, state) {
                final cubit = Step20Cubit.get(context);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Supportive tools",
                            style: TextStyles.font14W600.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              cubit.selectAllTools();
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
                                  style: TextStyles.font12WhiteColorW500
                                      .copyWith(color: AppColors.whiteColor),
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
              child: BlocBuilder<Step20Cubit, Step20State>(
                buildWhen: (previous, current) {
                  return current is GetSupportiveToolsLoading ||
                      current is GetSupportiveToolsSuccess ||
                      current is GetSupportiveToolsError ||
                      current is OnChangeSelectedState;
                },
                builder: (context, state) {
                  final cubit = Step20Cubit.get(context);

                  if (state is GetSupportiveToolsLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  if (state is GetSupportiveToolsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyles.font14W600.copyWith(
                          color: AppColors.redColor,
                        ),
                      ),
                    );
                  }

                  if (cubit.supportiveTools.isEmpty) {
                    return Center(
                      child: Text(
                        "No tools available",
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
                      itemCount: cubit.supportiveTools.length,
                      itemBuilder: (context, index) {
                        final tool = cubit.supportiveTools[index];
                        final isSelected = cubit.isToolSelected(tool);
                        return GymMachineCard(
                          imageUrl: tool.imageUrl,
                          title: tool.name,
                          description: tool.description,
                          isSelected: isSelected,
                          onTap: () {
                            cubit.toggleTool(tool);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            BlocConsumer<Step20Cubit, Step20State>(
              // buildWhen: (previous, current) {
              //   return current is OnRegisterLoadingState ||
              //       current is OnRegisterSuccessState ||
              //       current is OnRegisterErrorState ||
              //       current is OnRegisterCatchErrorState;
              // },
              listener: (context, state) {
                if (state is Step20SuccessState) {
                  context.completeOnboardingStepOrGo(Routes.step21Screen);
                } else if (state is Step20ErrorState) {
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
                    isLoading: state is Step20LoadingState,
                    borderRadius: 50,
                    buttonHeight: 46.h,
                    buttonText: "Next",
                    backGroundColor: AppColors.primaryColor,
                    borderColor: AppColors.primaryColor,
                    textStyle: TextStyles.font18blackColorW600,
                    onPressed: () {
                      final cubit = Step20Cubit.get(context);
                      if (cubit.isValid) {
                        cubit.sendStep();
                      } else {
                        AppConstant.toast(
                          "Please select at least one supportive tool",
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
