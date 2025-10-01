import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/sign_in/logic/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(InitialState());

  //1 == sign in and 2 ==sign up
  int signInState = 1;

  changeSignInState(int value) {
    signInState = value;
    emit(OnChangeSignInState());
  }

  ///login
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  //
  // changePasswordState() {
  //   isPasswordVisible = !isPasswordVisible;
  //   emit(IsPasswordVisibleState());
  // }
  //
  // sign_in() {
  //   emit(OnRegisterLoadingState());
  //   _registerRepo
  //       .sign_in(
  //         RegisterRequestModel(
  //           name: nameController.text,
  //           email: emailController.text,
  //           phone: phoneController.text,
  //           countryCode: countryCodeController.text,
  //           job: jobController.text,
  //           password: passwordController.text,
  //         ),
  //       )
  //       .then((value) {
  //         value.fold(
  //           (l) {
  //             emit(OnRegisterErrorState(message: l.message));
  //           },
  //           (r) async {
  //             emit(OnRegisterSuccessState(accountStatus: r.accountStatus));
  //           },
  //         );
  //       })
  //       .catchError((error) {
  //         emit(OnRegisterCatchErrorState());
  //       });
  // }
  //
  // Future<void> cashUserData(String token, String name) async {
  //   await CacheHelper.setSecuredString(ConstantKeys.saveTokenToShared, token);
  //   await CacheHelper.setSecuredString(ConstantKeys.saveNameToShared, name);
  // }

  ///register

  GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  TextEditingController registerNameController = TextEditingController();
  TextEditingController registerPhoneController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerBirthDateController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();

  bool isAgreeForTerms = false;

  changeAgreeForTerms() {
    isAgreeForTerms = !isAgreeForTerms;
    emit(OnChangeAgreeForTermsState());
  }

  static SignInCubit get(context) => BlocProvider.of(context);
}
