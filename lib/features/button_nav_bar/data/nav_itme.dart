import 'package:flutter/material.dart';

class NavItem {
  final IconData? icon;
  final String? activeAssetPath;
  final String? inactiveAssetPath;
  final String label;

  NavItem({
    this.icon,
    this.activeAssetPath,
    this.inactiveAssetPath,
    required this.label,
  }) : assert(
          icon != null || activeAssetPath != null,
          'Either icon or activeAssetPath must be provided',
        );

  bool get isSvg => activeAssetPath != null;
}
