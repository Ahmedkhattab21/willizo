import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/assets_manager.dart';

import 'package:willizo/features/onboarding/logic/onboarding_cubit.dart';
import 'package:willizo/features/onboarding/logic/onboarding_state.dart';
import 'package:willizo/features/onboarding/ui/widget/on_boarding_widget.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OnboardingCubit, OnboardingState>(
        buildWhen: (previous, current) {
          return current is OnChangeOnBoardingState;
        },
        builder: (context, state) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  OnboardingCubit.get(context).onBoardingPage == 1
                      ? ImageAsset.onBoarding1Image
                      : OnboardingCubit.get(context).onBoardingPage == 2
                      ? ImageAsset.onBoarding2Image
                      : ImageAsset.onBoarding3Image,
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: OnBoardingWidget(
                  page: OnboardingCubit.get(context).onBoardingPage,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
