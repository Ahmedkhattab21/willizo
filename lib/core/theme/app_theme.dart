import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/theme/color_extension.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class AppThemes {
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      extensions: const <ThemeExtension<dynamic>>[ColorsExtension.dark],
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.blackColor,
      primaryColor: AppColors.primaryColor,
      colorScheme: const ColorScheme.dark(primary: AppColors.primaryColor),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.sp),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.grey),
      ),
    );
  }
}
