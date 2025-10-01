import 'package:flutter/material.dart';

class ColorsExtension extends ThemeExtension<ColorsExtension> {
  final Color mainColor;

  const ColorsExtension({required this.mainColor});

  @override
  ThemeExtension<ColorsExtension> copyWith({Color? mainColor}) {
    return ColorsExtension(
      mainColor: mainColor ?? this.mainColor,
    );
  }

  @override
  ThemeExtension<ColorsExtension> lerp(
      covariant ThemeExtension<ColorsExtension>? other, double t) {
    if (other is! ColorsExtension) {
      return this;
    }
    return ColorsExtension(
      mainColor: Color.lerp(mainColor, other.mainColor, t) ?? mainColor,
    );
  }

  static const ColorsExtension light = ColorsExtension(
    mainColor: Colors.white,
  );

  static const ColorsExtension dark = ColorsExtension(
    mainColor: Color(0xFF1E1E1E), // لون مناسب للـ dark
  );
}
