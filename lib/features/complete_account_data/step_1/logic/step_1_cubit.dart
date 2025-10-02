import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_1/logic/step_1_state.dart';

class Step1Cubit extends Cubit<Step1State> {
  Step1Cubit() : super(InitialState());

  GlobalKey<FormState> key = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  static Step1Cubit get(context) => BlocProvider.of(context);
}
