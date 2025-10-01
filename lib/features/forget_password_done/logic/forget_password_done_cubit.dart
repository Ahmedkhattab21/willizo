import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/forget_password_done/logic/forget_password_done_state.dart';

class ForgetPasswordDoneCubit extends Cubit<ForgetPasswordDoneState> {
  ForgetPasswordDoneCubit() : super(InitialState());


  static ForgetPasswordDoneCubit get(context) => BlocProvider.of(context);
}
