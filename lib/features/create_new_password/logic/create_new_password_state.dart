abstract class CreateNewPasswordState {}

class InitialState extends CreateNewPasswordState {}

class CreateNewPasswordLoadingState extends CreateNewPasswordState {}

class CreateNewPasswordSuccessState extends CreateNewPasswordState {}

class CreateNewPasswordErrorState extends CreateNewPasswordState {
  final String error;
  CreateNewPasswordErrorState(this.error);
}