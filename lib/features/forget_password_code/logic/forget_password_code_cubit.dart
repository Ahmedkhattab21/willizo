import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/forget_password_code/logic/forget_password_code_state.dart';

class ForgetPasswordCodeCubit extends Cubit<ForgetPasswordCodeState> {
  ForgetPasswordCodeCubit() : super(InitialState());

  GlobalKey<FormState> forgetKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();



  static ForgetPasswordCodeCubit get(context) => BlocProvider.of(context);
}
