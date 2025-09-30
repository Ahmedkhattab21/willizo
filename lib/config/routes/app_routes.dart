import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/config/routes/routes.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;
    switch (settings.name) {
      // case Routes.splashVideoScreen:
      //   return MaterialPageRoute(builder: (_) => SplashVideoScreen());

      // case Routes.onBoardingScreen:
      //   return MaterialPageRoute(builder: (_) => OnBoardingScreen());

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
