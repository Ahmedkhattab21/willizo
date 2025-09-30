// import 'package:smart_app/core/utils/app_colors_white_theme.dart';
// import 'package:smart_app/config/routes/routes.dart';
// import 'package:smart_app/core/utils/app_constant.dart';
// import 'package:smart_app/core/utils/extentions.dart';
// import 'package:smart_app/core/utils/spacing.dart';
// import 'package:smart_app/core/utils/styles.dart';
// import 'package:smart_app/core/widgets/app_text_field.dart';
// import 'package:smart_app/core/widgets/button_widget.dart';
// import 'package:smart_app/features/user/login/logic/login_cubit.dart';
// import 'package:smart_app/features/user/login/logic/login_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             context.pop();
//           },
//           icon: Icon(Icons.arrow_back, color: AppColors.whiteColor),
//         ),
//         title: Text(
//           "Welcome Back",
//           style: TextStyles.font24BlackColorBold.copyWith(
//             color: AppColors.whiteColor,
//           ),
//         ),
//         backgroundColor: AppColors.redColor,
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 18.w),
//             child: Form(
//               key: LoginCubit.get(context).loginKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   verticalSpace(20),
//
//                   Text(
//                     "Sign in to discover, book, and dance for a cause 🎉",
//                     style: TextStyles.font13blackColorW500,
//                   ),
//                   verticalSpace(16),
//
//                   Container(
//                     height: 50.h,
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 10.w,
//                       vertical: 4.h,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12.r),
//                       color: AppColors.whiteColor,
//                       border: Border.all(
//                         color: AppColors.greyColor44.withValues(alpha: .1),
//                       ),
//                     ),
//
//                     child: BlocBuilder<LoginCubit, LoginState>(
//                       buildWhen: (previous, current) {
//                         return current is IsClientChangeStateState;
//                       },
//                       builder: (context, state) {
//                         return Row(
//                           children: [
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () {
//                                   LoginCubit.get(
//                                     context,
//                                   ).changeIsClientState(true);
//                                 },
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8.r),
//                                     color: LoginCubit.get(context).isClient
//                                         ? AppColors.redColor
//                                         : AppColors.whiteColor,
//                                   ),
//                                   child: Text(
//                                     "Client",
//                                     style: TextStyles.font13blackColorW500
//                                         .copyWith(
//                                           color:
//                                               LoginCubit.get(context).isClient
//                                               ? AppColors.whiteColor
//                                               : AppColors.blackColor,
//                                         ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             horizontalSpace(16),
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () {
//                                   LoginCubit.get(
//                                     context,
//                                   ).changeIsClientState(false);
//                                 },
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8.r),
//                                     color: LoginCubit.get(context).isClient
//                                         ? AppColors.whiteColor
//                                         : AppColors.redColor,
//                                   ),
//                                   child: Text(
//                                     "Sponsor",
//                                     style: TextStyles.font13blackColorW500
//                                         .copyWith(
//                                           color:
//                                               LoginCubit.get(context).isClient
//                                               ? AppColors.blackColor
//                                               : AppColors.whiteColor,
//                                         ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                   verticalSpace(16),
//
//                   Text("Email", style: TextStyles.font16blackColorW500),
//                   verticalSpace(4),
//                   AppTextFormField(
//                     hintText: "Enter your email ",
//                     hintStyle: TextStyles.font12blackColorW400,
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 12.h,
//                       horizontal: 20.w,
//                     ),
//                     textStyle: TextStyles.font12blackColorW400,
//                     controller: LoginCubit.get(context).emailController,
//                     backgroundColor: AppColors.whiteColor,
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: AppColors.greyColor44.withValues(alpha: .7),
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(24.r),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: AppColors.greyColor44.withValues(alpha: .7),
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(24.r),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: AppColors.redColor,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(24.r),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: AppColors.redColor,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(24.r),
//                     ),
//                     validator: (String? value) {
//                       if (value == null || value.isEmpty) {
//                         return "Enter Value";
//                       }
//                       return null;
//                     },
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   verticalSpace(16),
//                   Text("Password", style: TextStyles.font16blackColorW500),
//                   verticalSpace(4),
//                   BlocBuilder<LoginCubit, LoginState>(
//                     buildWhen: (previous, current) {
//                       return current is IsPasswordVisibleState;
//                     },
//                     builder: (context, state) {
//                       return AppTextFormField(
//                         hintText: "Create a password",
//                         hintStyle: TextStyles.font12blackColorW400,
//                         isObscureText: LoginCubit.get(
//                           context,
//                         ).isPasswordVisible,
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: 12.h,
//                           horizontal: 20.w,
//                         ),
//                         textStyle: TextStyles.font12blackColorW400,
//                         controller: LoginCubit.get(context).passwordController,
//                         backgroundColor: AppColors.whiteColor,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             LoginCubit.get(context).isPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: AppColors.greyColor44,
//                           ),
//                           onPressed: () {
//                             LoginCubit.get(context).changePasswordState();
//                           },
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: AppColors.greyColor44.withValues(alpha: .7),
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(24.r),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: AppColors.greyColor44.withValues(alpha: .7),
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(24.r),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: AppColors.redColor,
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(24.r),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: AppColors.redColor,
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(24.r),
//                         ),
//                         validator: (String? value) {
//                           if (value == null || value.isEmpty) {
//                             return "Enter Value";
//                           }
//                           return null;
//                         },
//                         keyboardType: TextInputType.text,
//                       );
//                     },
//                   ),
//                   verticalSpace(4),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           context.pushNamed(Routes.forgetPasswordScreen);
//                         },
//                         child: Text(
//                           "Forgot Password?",
//                           style: TextStyles.font14BlackColorW400,
//                         ),
//                       ),
//                     ],
//                   ),
//                   verticalSpace(180),
//                   BlocConsumer<LoginCubit, LoginState>(
//                     buildWhen: (previous, current) {
//                       return current is OnLoginLoadingState ||
//                           current is OnLoginSuccessState ||
//                           current is OnLoginErrorState ||
//                           current is OnLoginCatchErrorState;
//                     },
//                     listener: (context, state) {
//                       if (state is OnLoginSuccessState) {
//                         if (state.isClient) {
//                           AppConstant.toast(
//                             'Login successfully',
//                             AppColors.greenColor,
//                           );
//                           context.pushNamedAndRemoveUntil(
//                             Routes.buttonNavigationBarScreen,
//                             predicate: (predicate) => false,
//                             arguments: {'idGuest': false},
//                           );
//                         } else {
//                           AppConstant.toast(
//                             'Login successfully',
//                             AppColors.greenColor,
//                           );
//                           context.pushNamedAndRemoveUntil(
//                             Routes.sponsorButtonNavigationBarSceen,
//                             predicate: (predicate) => false,
//                           );
//                         }
//                       } else if (state is OnLoginErrorState) {
//                         AppConstant.toast(
//                           'Email Or Password is Wrong',
//                           AppColors.redColor,
//                         );
//                       } else if (state is OnLoginCatchErrorState) {
//                         AppConstant.toast(
//                           'Email Or Password is Wrong',
//                           AppColors.redColor,
//                         );
//                       }
//                     },
//                     builder: (context, state) {
//                       return ButtonWidget(
//                         isLoading: state is OnLoginLoadingState,
//                         borderRadius: 50,
//                         buttonHeight: 46.h,
//                         buttonText: "Sign In",
//                         backGroundColor: AppColors.redColor,
//                         borderColor: AppColors.redColor,
//                         textStyle: TextStyles.font16whiteColorW600,
//                         onPressed: () {
//                           validateRegister(context);
//                         },
//                       );
//                     },
//                   ),
//                   verticalSpace(16),
//
//                   BlocBuilder<LoginCubit, LoginState>(
//                     buildWhen: (previous, current) {
//                       return current is IsClientChangeStateState;
//                     },
//                     builder: (context, state) {
//                       if (LoginCubit.get(context).isClient) {
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Don't have an account? ",
//                               style: TextStyles.font16BlackColorBold,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 context.pushNamed(Routes.registerScreen);
//                               },
//                               child: Text(
//                                 "Sign Up",
//                                 style: TextStyles.font16BlackColorBold.copyWith(
//                                   color: AppColors.redColor,
//                                   fontWeight: FontWeight.bold,
//                                   decoration: TextDecoration.underline,
//                                   decorationColor: AppColors.redColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       } else {
//                         return SizedBox.shrink();
//                       }
//                     },
//                   ),
//                   verticalSpace(40),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void validateRegister(BuildContext context) {
//     if (LoginCubit.get(context).loginKey.currentState!.validate()) {
//       LoginCubit.get(context).login();
//     }
//   }
// }
