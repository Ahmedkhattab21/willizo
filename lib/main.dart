// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/my_app.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/cache_helper.dart';
import 'core/services/services_locator.dart';
import 'core/services/watch_workout_sync_service.dart';
import 'core/utils/app_constant.dart';
import 'observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await EasyLocalization.ensureInitialized();
  await ServicesLocator.init();
  await CacheHelper.init();
  WatchWorkoutSyncService.initialize();
  await WatchWorkoutSyncService.syncAuthenticationSession();
  // PusherService.initPusher();

  ///

  Bloc.observer = Observer();

  try {
    await checkIfLoggedInUser();
    await checkUserType();
  } catch (e) {
    isLoggedInUser = false;
    userType = null;
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      saveLocale: true,
      startLocale: const Locale('en', 'US'),
      path: 'assets/languages',
      fallbackLocale: const Locale('en', 'US'),
      child: MyApp(
        navigateWidget: Routes.splashVideoScreen,
        // isLoggedInUser
        //     ? (userType == 'client'
        //           ? Routes.buttonNavigationBarScreen
        //           : Routes.sponsorButtonNavigationBarSceen)
        //     : Routes.onBoardingScreen,
      ),
    ),
  );
}

Future<void> checkIfLoggedInUser() async {
  String? userToken = await CacheHelper.getSecuredString(
    ConstantKeys.saveTokenToShared,
  );
  isLoggedInUser = !(userToken == null || userToken.isEmpty);
}

Future<void> checkUserType() async {
  String? type = await CacheHelper.getSecuredString(
    ConstantKeys.saveUserTypeToShared,
  );
  if (type != null && type.isNotEmpty) {
    userType = type;
  } else {
    userType = null;
  }
}

