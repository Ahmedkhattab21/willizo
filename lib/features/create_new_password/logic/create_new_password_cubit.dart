import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/create_new_password/data/models/reset_password_request_model.dart';
import 'package:willizo/features/create_new_password/data/repo/reset_password_repo.dart';
import 'package:willizo/features/create_new_password/logic/create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit(this.resetPasswordRepo) : super(InitialState());

  final ResetPasswordRepo resetPasswordRepo;

  GlobalKey<FormState> createPasswordKey = GlobalKey<FormState>();

  TextEditingController otpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmForgetPasswordController =
      TextEditingController();

  static CreateNewPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> resetPassword() async {
    emit(CreateNewPasswordLoadingState());
    final requestModel = ResetPasswordRequestModel(
      emailOrPhone: emailController.text,
      code: otpController.text,
      newPassword: passwordController.text,
      confirmPassword: confirmForgetPasswordController.text,
    );

    resetPasswordRepo
        .resetPassword(requestModel: requestModel)
        .then((value) {
          value.fold(
            (l) => emit(CreateNewPasswordErrorState(l.message)),
            (r) => emit(CreateNewPasswordSuccessState()),
          );
        })
        .catchError((error) {
          emit(CreateNewPasswordErrorState(error.toString()));
        });
  }

  @override
  Future<void> close() {
    otpController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmForgetPasswordController.dispose();
    return super.close();
  }
}
