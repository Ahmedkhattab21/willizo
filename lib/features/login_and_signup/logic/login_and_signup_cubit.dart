import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/services/watch_workout_sync_service.dart';
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
              await WatchWorkoutSyncService.syncAuthenticationSession(
                accessToken: r.data?.tokens?.accessToken,
                refreshToken: r.data?.tokens?.refreshToken,
                tokenType: r.data?.tokens?.tokenType ?? 'bearer',
                expiresIn: r.data?.tokens?.expiresIn,
              );
              // Save user name if available
              if (r.data?.user?.fullName != null) {
                await CacheHelper.setSecuredString(
                  ConstantKeys.saveNameToShared,
                  r.data!.user!.fullName!,
                );
              }
              final nextRoute = await _getNextRouteAfterAuth(
                fallbackRoute: Routes.buttonNavBarWidget,
              );
              emit(LoginSuccessState(nextRoute));
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

  final List<String> countryDialCodes = const [
    '+20',
    '+966',
    '+971',
    '+965',
    '+974',
    '+973',
    '+968',
    '+962',
    '+1',
  ];
  String selectedCountryDialCode = '+20';
  bool isAgreeForTerms = false;

  void changeCountryDialCode(String code) {
    selectedCountryDialCode = code;
    emit(OnChangeCountryDialCodeState());
  }

  String get registerFullPhoneNumber {
    final rawPhone = registerPhoneController.text.trim().replaceAll(
      RegExp(r'[\s-]'),
      '',
    );
    if (rawPhone.startsWith('+')) return rawPhone;
    if (rawPhone.startsWith('00')) return '+${rawPhone.substring(2)}';
    if (rawPhone.startsWith('0')) {
      return '$selectedCountryDialCode${rawPhone.substring(1)}';
    }
    return '$selectedCountryDialCode$rawPhone';
  }

  Future<void> signup() async {
    emit((SignupLoadingState()));
    loginRepo
        .signup(
          SignupRequestModel(
            fullName: registerNameController.text,
            email: registerEmailController.text,
            phoneNumber: registerFullPhoneNumber,
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
              await WatchWorkoutSyncService.syncAuthenticationSession(
                accessToken: r.data?.tokens?.accessToken,
                refreshToken: r.data?.tokens?.refreshToken,
                tokenType: r.data?.tokens?.tokenType ?? 'bearer',
                expiresIn: r.data?.tokens?.expiresIn,
              );
              if (r.data?.user?.fullName != null) {
                await CacheHelper.setSecuredString(
                  ConstantKeys.saveNameToShared,
                  r.data!.user!.fullName!,
                );
              }
              final nextRoute = await _getNextRouteAfterAuth(
                fallbackRoute: Routes.step1Screen,
              );
              emit(SignupSuccessState(nextRoute));
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

  Future<String> _getNextRouteAfterAuth({required String fallbackRoute}) async {
    final result = await loginRepo.getOnboardingStatus();
    return result.fold((_) => fallbackRoute, (response) {
      if (response.data.isCompleted) {
        return Routes.buttonNavBarWidget;
      }
      if (response.data.nextStep > response.data.totalSteps) {
        return Routes.buttonNavBarWidget;
      }
      return Routes.getStepRoute(response.data.nextStep);
    });
  }

  static LoginAndSignup get(context) => BlocProvider.of(context);
}
