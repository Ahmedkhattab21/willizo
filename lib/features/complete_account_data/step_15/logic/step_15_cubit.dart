import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_15/logic/step_15_state.dart';

class Step15Cubit extends Cubit<Step15State> {
  Step15Cubit() : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<AllergicItem> yesAndNo = [
    AllergicItem(id: 1, name: 'Yes'),
    AllergicItem(id: 2, name: 'No'),
  ];

  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  static Step15Cubit get(context) => BlocProvider.of(context);
}

class AllergicItem {
  int id;
  String name;

  AllergicItem({required this.id, required this.name});
}
