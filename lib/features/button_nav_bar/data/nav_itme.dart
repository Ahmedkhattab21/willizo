import 'package:flutter/material.dart';

class NavItem {
  final IconData? icon;
  final String? assetPath;
  final String label;

  NavItem({this.icon, this.assetPath, required this.label})
    : assert(
        icon != null || assetPath != null,
        'Either icon or svgPath must be provided',
      );

  bool get isSvg => assetPath != null;
}
