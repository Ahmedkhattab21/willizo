import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/config/themes/app_black_theme.dart';
import 'package:willizo/core/theme/app_theme.dart';
import 'package:willizo/core/widgets/offline_alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/routes/app_routes.dart';
import 'core/utils/app_colors_white_theme.dart';

class MyApp extends StatefulWidget {
  final String navigateWidget;

  const MyApp({required this.navigateWidget, super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _listenToNetwork();
  }

  void _listenToNetwork() {
    // MyConnectivity.myStream.listen((event) {
    //   if (!MyConnectivity.isOnline()) {
    //     _showOfflineDialog();
    //   }
    // });
  }

  void _showOfflineDialog() {
    if (MyApp.navigatorKey.currentContext == null) return;
    OfflineAlertDialog.getDialog();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, snapshot) {
        // getIt<AppConstant>().setLanguage(context.locale.languageCode);

        return Container(
          color: AppColors.whiteColor,
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            navigatorKey: MyApp.navigatorKey,
            title: "willizo",
            theme: blackThemeData(),
            initialRoute: Routes.notificationScreen,
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        );
      },
    );
  }
}
