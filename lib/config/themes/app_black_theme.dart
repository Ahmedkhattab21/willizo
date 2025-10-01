import 'package:flutter/material.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

ThemeData blackThemeData() => ThemeData(
  // fontFamily: "Mosquich",
  scaffoldBackgroundColor: AppColors.darkColor,
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    // color: AppColors.whiteColor,
    centerTitle: true,
  ),
  // scaffoldBackgroundColor: AppColors.whiteColor,
);
