import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/features/login_and_signup/data/repo/login_and_signup_repo.dart';

class SplashVideoScreen extends StatefulWidget {
  const SplashVideoScreen({super.key});

  @override
  State<SplashVideoScreen> createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<SplashVideoScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // Wait for splash screen duration
    await Future.delayed(const Duration(seconds: 3));

    // Check if user has token
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );

    if (token != null && token.isNotEmpty) {
      // User has token, check onboarding status
      try {
        final repo = getIt<LoginAndSignupRepo>();
        final result = await repo.getOnboardingStatus();

        result.fold(
          (failure) {
            // If API call fails, navigate to home screen if token exists
            if (mounted) {
              context.pushReplacementNamed(Routes.buttonNavBarWidget);
            }
          },
          (response) {
            // Check if onboarding is completed
            if (response.data.isCompleted) {
              // Navigate to home screen
              if (mounted) {
                context.pushReplacementNamed(Routes.buttonNavBarWidget);
              }
            } else {
              // Navigate to the current step
              final stepRoute = Routes.getStepRoute(response.data.currentStep);
              if (mounted) {
                context.pushReplacementNamed(stepRoute);
              }
            }
          },
        );
      } catch (e) {
        // If error occurs, navigate to home screen
        if (mounted) {
          context.pushReplacementNamed(Routes.buttonNavBarWidget);
        }
      }
    } else {
      // No token, check if onboarding was already shown
      final bool isBoardingCompleted = await CacheHelper.getBool(
        ConstantKeys.saveIsShowIsBoardingToShared,
      );

      if (mounted) {
        if (isBoardingCompleted) {
          context.pushReplacementNamed(Routes.signInScreen);
        } else {
          context.pushReplacementNamed(Routes.onBoardingScreen);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Center(
        child: SvgPicture.asset('assets/svgs/willizo_logo_splash.svg'),
      ),
    );
  }
}
