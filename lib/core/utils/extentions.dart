import 'package:flutter/material.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';

extension NavigationScreens on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  Future<void> clearAuthAndOpenSignIn() async {
    await CacheHelper.removeSecureData(ConstantKeys.saveTokenToShared);
    await CacheHelper.removeSecureData(ConstantKeys.saveRefreshTokenToShared);
    await CacheHelper.removeSecureData(ConstantKeys.saveNameToShared);
    await CacheHelper.removeSecureData(ConstantKeys.saveEmailToShared);
    await CacheHelper.removeSecureData(ConstantKeys.savePhoneToShared);

    if (!mounted) return;
    await pushNamedAndRemoveUntil(
      Routes.signInScreen,
      predicate: (route) => false,
    );
  }

  bool get isEditingOnboardingStep {
    final args = ModalRoute.of(this)?.settings.arguments;
    return args is Map && args['isEditing'] == true;
  }

  Future<void> closeEditingStepOrOpenSignIn() async {
    if (isEditingOnboardingStep) {
      pop();
      return;
    }

    await clearAuthAndOpenSignIn();
  }

  Future<void> completeOnboardingStepOrGo(
    String routeName, {
    bool removeUntil = false,
  }) async {
    if (isEditingOnboardingStep) {
      pop();
      return;
    }

    if (removeUntil) {
      await pushNamedAndRemoveUntil(routeName, predicate: (route) => false);
      return;
    }

    await pushNamed(routeName);
  }

  void pop() => Navigator.of(this).pop();
}

extension MediaQueryValues on BuildContext {
  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  double get topPadding => MediaQuery.of(this).padding.top;

  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  double get viewInsetsBottom => MediaQuery.of(this).viewInsets.bottom;
}

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}
