import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_4/logic/step_4_state.dart';

class Step4Cubit extends Cubit<Step4State> {
  Step4Cubit() : super(InitialState());

  int selectedHeight = 100;

  onChangeSelectedHeight(int value) {
    selectedHeight = value;
    emit(OnChangeSelectedState());
  }

  static Step4Cubit get(context) => BlocProvider.of(context);
}
