import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/forget_password/logic/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(InitialState());

  GlobalKey<FormState> forgetKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  static ForgetPasswordCubit get(context) => BlocProvider.of(context);
}
