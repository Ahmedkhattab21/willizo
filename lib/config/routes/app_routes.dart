import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/features/complete_account_data/step_1/logic/step_1_cubit.dart';
import 'package:willizo/features/complete_account_data/step_1/ui/step_1_screen.dart';
import 'package:willizo/features/complete_account_data/step_2/logic/step_2_cubit.dart';
import 'package:willizo/features/complete_account_data/step_2/ui/step_2_screen.dart';
import 'package:willizo/features/complete_account_data/step_3/logic/step_3_cubit.dart';
import 'package:willizo/features/complete_account_data/step_3/ui/step_3_screen.dart';
import 'package:willizo/features/create_new_password/logic/create_new_password_cubit.dart';
import 'package:willizo/features/create_new_password/ui/create_new_password_screen.dart';
import 'package:willizo/features/create_new_password_done/ui/create_new_password_done_screen.dart';
import 'package:willizo/features/forget_password/logic/forget_password_cubit.dart';
import 'package:willizo/features/forget_password/ui/forget_password_screen.dart';
import 'package:willizo/features/forget_password_code/logic/forget_password_code_cubit.dart';
import 'package:willizo/features/forget_password_code/ui/forget_password_code_screen.dart';
import 'package:willizo/features/forget_password_done/logic/forget_password_done_cubit.dart';
import 'package:willizo/features/forget_password_done/ui/forget_password_done_screen.dart';
import 'package:willizo/features/onboarding/logic/onboarding_cubit.dart';
import 'package:willizo/features/onboarding/ui/onboarding_screen.dart';
import 'package:willizo/features/sign_in/logic/sign_in_cubit.dart';
import 'package:willizo/features/sign_in/ui/sign_in_screen.dart';
import 'package:willizo/features/splash/ui/splash_video_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;
    switch (settings.name) {
      case Routes.splashVideoScreen:
        return MaterialPageRoute(builder: (_) => SplashVideoScreen());

      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => OnboardingCubit(),
            child: OnBoardingScreen(),
          ),
        );

      case Routes.signInScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SignInCubit(),
            child: SignInScreen(),
          ),
        );
      case Routes.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ForgetPasswordCubit(),
            child: ForgetPasswordScreen(),
          ),
        );
      case Routes.forgetPasswordCodeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ForgetPasswordCodeCubit(),
            child: ForgetPasswordCodeScreen(),
          ),
        );
      case Routes.forgetPasswordDoneScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ForgetPasswordDoneCubit(),
            child: ForgetPasswordDoneScreen(),
          ),
        );
      case Routes.createNewPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CreateNewPasswordCubit(),
            child: CreateNewPasswordScreen(),
          ),
        );
      case Routes.createNewPasswordDoneScreen:
        return MaterialPageRoute(builder: (_) => CreateNewPasswordDoneScreen());

      ///steps
      case Routes.step1Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step1Cubit(),
            child: Step1Screen(),
          ),
        );
      case Routes.step2Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step2Cubit(),
            child: Step2Screen(),
          ),
        );
      case Routes.step3Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step3Cubit(),
            child: Step3Screen(),
          ),
        );
      // ///user routes
      // case Routes.loginScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (context) => LoginCubit(getIt()),
      //       child: LoginScreen(),
      //     ),
      //   );

      // case Routes.chatScreen:
      //   return MaterialPageRoute(builder: (_) => AllChatsScreen());
      default:
        return null;
    }
  }
}
