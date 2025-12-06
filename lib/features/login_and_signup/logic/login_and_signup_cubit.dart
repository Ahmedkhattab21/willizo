import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/login_and_signup/data/models/login_request_model.dart';
import 'package:willizo/features/login_and_signup/data/models/signup_request_model.dart';
import 'package:willizo/features/login_and_signup/data/repo/login_and_signup_repo.dart';
import 'package:willizo/features/login_and_signup/logic/login_and_signup_state.dart';

class LoginAndSignup extends Cubit<LoginAndSignupState> {
  LoginAndSignup(this.loginRepo) : super(InitialState());
  final LoginAndSignupRepo loginRepo;
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
  Future<void> login() async {
    emit(LoginLoadingState());
    loginRepo
        .lgoin(
          LoginRequestModel(
            email: loginEmailController.text,
            password: loginPasswordController.text,
          ),
        )
        .then((value) async {
          value.fold(
            (l) {
              emit(LoginFailureState(l.message));
            },
            (r) async {
              // Save token to SharedPreferences
              if (r.data?.tokens?.accessToken != null) {
                await CacheHelper.setSecuredString(
                  ConstantKeys.saveTokenToShared,
                  r.data!.tokens!.accessToken!,
                );
              }
              // Save refresh token to SharedPreferences
              if (r.data?.tokens?.refreshToken != null) {
                await CacheHelper.setSecuredString(
                  ConstantKeys.saveRefreshTokenToShared,
                  r.data!.tokens!.refreshToken!,
                );
              }
              // Save user name if available
              if (r.data?.user?.fullName != null) {
                await CacheHelper.setSecuredString(
                  ConstantKeys.saveNameToShared,
                  r.data!.user!.fullName!,
                );
              }
              emit(LoginSuccessState());
            },
          );
        })
        .catchError((error) {
          emit(LoginFailureState(error.toString()));
        });
  }

  ///register

  GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  TextEditingController registerNameController = TextEditingController();
  TextEditingController registerPhoneController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerBirthDateController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();

  bool isAgreeForTerms = false;

  Future<void> signup() async {
    emit((SignupLoadingState()));
    loginRepo
        .signup(
          SignupRequestModel(
            fullName: registerNameController.text,
            email: registerEmailController.text,
            phoneNumber: registerPhoneController.text,
            dateOfBirth: registerBirthDateController.text,
            password: registerPasswordController.text,
            passwordConfirmation: registerPasswordController.text,
          ),
        )
        .then((value) async {
          value.fold(
            (l) {
              emit(SignupFailureState(l.message));
            },
            (r) async {
              if (r.data?.tokens?.accessToken != null) {
                await CacheHelper.setSecuredString(
                  ConstantKeys.saveTokenToShared,
                  r.data!.tokens!.accessToken!,
                );
              }
              if (r.data?.tokens?.refreshToken != null) {
                await CacheHelper.setSecuredString(
                  ConstantKeys.saveRefreshTokenToShared,
                  r.data!.tokens!.refreshToken!,
                );
              }
              if (r.data?.user?.fullName != null) {
                await CacheHelper.setSecuredString(
                  ConstantKeys.saveNameToShared,
                  r.data!.user!.fullName!,
                );
              }
              emit(SignupSuccessState());
            },
          );
        })
        .catchError((error) {
          emit(SignupFailureState(error.toString()));
        });
  }

  changeAgreeForTerms() {
    isAgreeForTerms = !isAgreeForTerms;
    emit(OnChangeAgreeForTermsState());
  }

  static LoginAndSignup get(context) => BlocProvider.of(context);
}
