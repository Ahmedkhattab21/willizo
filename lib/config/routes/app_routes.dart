import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/features/onboarding/ui/onboarding_screen.dart';
import 'package:willizo/features/splash/ui/splash_video_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;
    switch (settings.name) {
      case Routes.splashVideoScreen:
        return MaterialPageRoute(builder: (_) => SplashVideoScreen());

      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());

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
