abstract class LoginAndSignupState {}

class InitialState extends LoginAndSignupState {}
class OnChangeSignInState extends LoginAndSignupState {}
class OnChangeAgreeForTermsState extends LoginAndSignupState {}

class LoginLoadingState extends LoginAndSignupState {}
class LoginSuccessState extends LoginAndSignupState {}
class LoginFailureState extends LoginAndSignupState {
  final String error;
  LoginFailureState(this.error);
}

class SignupLoadingState extends LoginAndSignupState {}
class SignupSuccessState extends LoginAndSignupState {}
class SignupFailureState extends LoginAndSignupState {
  final String error;
  SignupFailureState(this.error);
}