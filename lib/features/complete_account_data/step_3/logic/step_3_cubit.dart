import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_3/logic/step_3_state.dart';

class Step3Cubit extends Cubit<Step3State> {
  Step3Cubit() : super(InitialState());

  List<GenderItem> genders = [
    GenderItem(id: 1, name: 'Male'),
    GenderItem(id: 2, name: 'Female'),
  ];

  int selectedGender = 1;

  changeSelectedGender(int value) {
    selectedGender = value;
    emit(OnChangeSelectedState());
  }

  static Step3Cubit get(context) => BlocProvider.of(context);
}

class GenderItem {
  int id;
  String name;

  GenderItem({required this.id, required this.name});
}
