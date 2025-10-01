import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/create_new_password/logic/create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit() : super(InitialState());


   GlobalKey<FormState> createPasswordKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmForgetPasswordController = TextEditingController();


  static CreateNewPasswordCubit get(context) => BlocProvider.of(context);
}
