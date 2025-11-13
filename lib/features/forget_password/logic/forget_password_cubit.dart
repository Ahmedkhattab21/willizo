import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/forget_password/data/repo/forget_password_repo.dart';
import 'package:willizo/features/forget_password/logic/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this.forgetPasswordRepo) : super(InitialState());
  final ForgetPasswordRepo forgetPasswordRepo;

  GlobalKey<FormState> forgetKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  static ForgetPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> forgetPassword() async {
    emit(ForgetPasswordLoadingState());
    forgetPasswordRepo
        .forgetPassword(emailOrPhone: emailController.text)
        .then((value) {
          value.fold(
            (l) => emit(ForgetPasswordErrorState(l.message)),
            (r) => emit(ForgetPasswordSuccessState()),
          );
        })
        .catchError((error) {
          emit(ForgetPasswordErrorState(error.toString()));
        });
  }
}
