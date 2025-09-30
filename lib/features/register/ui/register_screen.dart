// import 'package:smart_app/core/utils/app_colors_white_theme.dart';
// import 'package:smart_app/config/routes/routes.dart';
// import 'package:smart_app/core/utils/app_constant.dart';
// import 'package:smart_app/core/utils/extentions.dart';
// import 'package:smart_app/core/utils/spacing.dart';
// import 'package:smart_app/core/utils/styles.dart';
// import 'package:smart_app/core/widgets/app_text_field.dart';
// import 'package:smart_app/core/widgets/button_widget.dart';
// import 'package:smart_app/features/user/register/logic/register_cubit.dart';
// import 'package:smart_app/features/user/register/logic/register_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:country_code_picker/country_code_picker.dart';
//
// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});
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
//           'Create Your Account',
//           style: TextStyles.font24BlackColorBold.copyWith(
//             color: AppColors.whiteColor,
//           ),
//         ),
//         backgroundColor: AppColors.redColor,
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         // decoration: BoxDecoration(
//         //   image: DecorationImage(
//         //     image: AssetImage(ImageAsset.authBackGroundImage),
//         //     fit: BoxFit.cover,
//         //   ),
//         // ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 18.w),
//             child: Form(
//               key: RegisterCubit.get(context).registerKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   verticalSpace(40),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 4.h,
//                           decoration: BoxDecoration(
//                             color: AppColors.redColor,
//                             borderRadius: BorderRadius.circular(24.r),
//                           ),
//                         ),
//                       ),
//                       horizontalSpace(12),
//                       Expanded(
//                         child: Container(
//                           height: 4.h,
//                           decoration: BoxDecoration(
//                             color: AppColors.greyColor44.withValues(alpha: .2),
//                             borderRadius: BorderRadius.circular(24.r),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   verticalSpace(40),
//                   Text("Full Name", style: TextStyles.font16blackColorW500),
//                   verticalSpace(4),
//                   AppTextFormField(
//                     hintText: "Enter your full name",
//                     hintStyle: TextStyles.font12blackColorW400,
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 12.h,
//                       horizontal: 20.w,
//                     ),
//                     textStyle: TextStyles.font12blackColorW400,
//                     controller: RegisterCubit.get(context).nameController,
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
//                     keyboardType: TextInputType.name,
//                   ),
//                   verticalSpace(16),
//
//                   Text("Email", style: TextStyles.font16blackColorW500),
//                   verticalSpace(4),
//                   AppTextFormField(
//                     hintText: "example@email.com",
//                     hintStyle: TextStyles.font12blackColorW400,
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 12.h,
//                       horizontal: 20.w,
//                     ),
//                     textStyle: TextStyles.font12blackColorW400,
//                     controller: RegisterCubit.get(context).emailController,
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
//
//                   verticalSpace(16),
//                   Text("Phone Number", style: TextStyles.font16blackColorW500),
//                   verticalSpace(4),
//                   AppTextFormField(
//                     hintText: "Enter your mobile number",
//                     hintStyle: TextStyles.font12blackColorW400,
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 12.h,
//                       horizontal: 20.w,
//                     ),
//                     prefixIcon: SizedBox(
//                       width: 120.w,
//                       child: CountryCodePicker(
//                         onChanged: (CountryCode code) {
//                           RegisterCubit.get(
//                             context,
//                           ).countryCodeController.text = code
//                               .toString();
//                         },
//                         initialSelection: 'EG',
//                         favorite: const ['EG'],
//                         showCountryOnly: false,
//                         showOnlyCountryWhenClosed: false,
//                         alignLeft: true,
//                         textStyle: TextStyle(color: AppColors.whiteColor),
//                         flagDecoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     ),
//                     textStyle: TextStyles.font12blackColorW400,
//                     controller: RegisterCubit.get(context).phoneController,
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
//                     keyboardType: TextInputType.phone,
//                   ),
//                   verticalSpace(16),
//
//                   Text("Job", style: TextStyles.font16blackColorW500),
//                   verticalSpace(4),
//                   AppTextFormField(
//                     hintText: "Enter Your job",
//                     hintStyle: TextStyles.font12blackColorW400,
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 12.h,
//                       horizontal: 20.w,
//                     ),
//                     textStyle: TextStyles.font12blackColorW400,
//                     controller: RegisterCubit.get(context).jobController,
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
//                     keyboardType: TextInputType.name,
//                   ),
//                   verticalSpace(16),
//                   Text("Password", style: TextStyles.font16blackColorW500),
//                   verticalSpace(4),
//                   BlocBuilder<RegisterCubit, RegisterState>(
//                     buildWhen: (previous, current) {
//                       return current is IsPasswordVisibleState;
//                     },
//                     builder: (context, state) {
//                       return AppTextFormField(
//                         hintText: "Create a password",
//                         hintStyle: TextStyles.font12blackColorW400,
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: 12.h,
//                           horizontal: 20.w,
//                         ),
//                         isObscureText: RegisterCubit.get(
//                           context,
//                         ).isPasswordVisible,
//                         textStyle: TextStyles.font12blackColorW400,
//                         controller: RegisterCubit.get(
//                           context,
//                         ).passwordController,
//                         backgroundColor: AppColors.whiteColor,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             RegisterCubit.get(context).isPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: AppColors.greyColor44,
//                           ),
//                           onPressed: () {
//                             RegisterCubit.get(context).changePasswordState();
//                           },
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: AppColors.greyColor44.withValues(alpha: .2),
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(24.r),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: AppColors.greyColor44.withValues(alpha: .2),
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
//                   verticalSpace(60),
//                   BlocConsumer<RegisterCubit, RegisterState>(
//                     buildWhen: (previous, current) {
//                       return current is OnRegisterLoadingState ||
//                           current is OnRegisterSuccessState ||
//                           current is OnRegisterErrorState ||
//                           current is OnRegisterCatchErrorState;
//                     },
//                     listener: (context, state) {
//                       if (state is OnRegisterSuccessState) {
//                         AppConstant.toast(
//                           "Register successfully. ",
//                           AppColors.greenColor,
//                         );
//                         if (state.accountStatus == 'pending') {
//                           ///
//                           context.pushNamed(Routes.registerDoneScreen);
//                         } else if (state.accountStatus ==
//                             'awaiting_verification') {
//                           context.pushNamed(
//                             Routes.registerOtpScreen,
//                             arguments: {
//                               'email': RegisterCubit.get(
//                                 context,
//                               ).emailController.text,
//                             },
//                           );
//                         }
//                       } else if (state is OnRegisterErrorState) {
//                         AppConstant.toast(state.message, AppColors.redColor);
//                       } else if (state is OnRegisterCatchErrorState) {
//                         AppConstant.toast(
//                           "Something wrong tray again later!",
//                           AppColors.redColor,
//                         );
//                       }
//                     },
//                     builder: (context, state) {
//                       return ButtonWidget(
//                         isLoading: state is OnRegisterLoadingState,
//                         borderRadius: 50,
//                         buttonHeight: 46.h,
//                         buttonText: "Sign Up",
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
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Already have an account? ",
//                         style: TextStyles.font16BlackColorBold,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           context.pushNamed(Routes.loginScreen);
//                         },
//                         child: Text(
//                           "Sign In",
//                           style: TextStyles.font16BlackColorBold.copyWith(
//                             color: AppColors.redColor,
//                             fontWeight: FontWeight.bold,
//                             decoration: TextDecoration.underline,
//                             decorationColor: AppColors.redColor,
//                           ),
//                         ),
//                       ),
//                     ],
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
//     if (RegisterCubit.get(context).registerKey.currentState!.validate()) {
//       RegisterCubit.get(context).register();
//     }
//   }
// }
