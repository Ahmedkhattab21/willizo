import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/sign_in/logic/sign_in_cubit.dart';
import 'package:willizo/features/sign_in/logic/sign_in_state.dart';
import 'package:willizo/features/sign_in/ui/widgets/login_widget.dart';
import 'package:willizo/features/sign_in/ui/widgets/register_widget.dart';
import 'package:willizo/features/sign_in/ui/widgets/taps_widget.dart';

class CreateNewPasswordDoneScreen extends StatelessWidget {
  const CreateNewPasswordDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpace(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      height: 30.r,
                      width: 30.r,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(40),
              Image.asset(ImageAsset.appLogoImage),
              verticalSpace(50),
              SvgPicture.asset(ImageAsset.selectedBoxIcon, height: 70.h),
              verticalSpace(50),
              Text(
                'Password Changed Successfully',
                textAlign: TextAlign.center,
                style: TextStyles.font24primaryColorW600,
              ),
              verticalSpace(32),
              ButtonWidget(
                isLoading: false,
                borderRadius: 10,
                buttonHeight: 46.h,
                buttonText: "Back to login",
                backGroundColor: AppColors.primaryColor,
                borderColor: AppColors.primaryColor,
                textStyle: TextStyles.font18blackColorW600,
                onPressed: () {
                  context.pop();
                  context.pop();
                  context.pop();
                  context.pop();
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void validateRegister(BuildContext context) {
  //   if (RegisterCubit.get(context).registerKey.currentState!.validate()) {
  //     RegisterCubit.get(context).sign_in();
  //   }
  // }
}
