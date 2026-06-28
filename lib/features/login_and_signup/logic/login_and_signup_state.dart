abstract class LoginAndSignupState {}

class InitialState extends LoginAndSignupState {}

class OnChangeSignInState extends LoginAndSignupState {}

class OnChangeAgreeForTermsState extends LoginAndSignupState {}

class LoginLoadingState extends LoginAndSignupState {}

class LoginSuccessState extends LoginAndSignupState {
  final String nextRoute;

  LoginSuccessState(this.nextRoute);
}

class LoginFailureState extends LoginAndSignupState {
  final String error;
  LoginFailureState(this.error);
}

class SignupLoadingState extends LoginAndSignupState {}

class SignupSuccessState extends LoginAndSignupState {
  final String nextRoute;

  SignupSuccessState(this.nextRoute);
}

class SignupFailureState extends LoginAndSignupState {
  final String error;
  SignupFailureState(this.error);
}
