import 'package:willizo/my_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfflineAlertDialog {
  const OfflineAlertDialog();

  static getDialog() {
    showDialog(
      context: MyApp.navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("noInternet".tr()),
          content: Text("noInternetText".tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ok".tr()),
            ),
          ],
        );
      },
    );
  }
}
