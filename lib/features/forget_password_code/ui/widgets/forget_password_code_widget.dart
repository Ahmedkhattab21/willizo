import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/forget_password_code/logic/forget_password_code_cubit.dart';

import '../../../../core/utils/app_colors_white_theme.dart';

class ForgetPasswordCodeWidget extends StatelessWidget {
  const ForgetPasswordCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 6,
      keyboardType: TextInputType.number,
      enableSuggestions: true,
      controller: ForgetPasswordCodeCubit.get(context).codeController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
      defaultPinTheme: PinTheme(
        width: 48.r,
        height: 48.r,
        textStyle: TextStyles.font20primaryColorW600,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 48.r,
        height: 48.r,
        textStyle: TextStyles.font20primaryColorW600,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: 48.r,
        height: 48.r,
        textStyle: TextStyles.font20primaryColorW600,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      showCursor: true,
      onCompleted: (String? value) {
        // if (MyConnectivity.isOnline()) {
        // SendCodeCubit.get(context).verifyCode();
        // } else {
        //   AppConstant.toast("Check Internet Connection", AppColors.redColor);
        // }
      },
    );
  }
}
