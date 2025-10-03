import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_16/logic/step_16_state.dart';

class Step16Cubit extends Cubit<Step16State> {
  Step16Cubit() : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<FoodItem> yesAndNo = [
    FoodItem(id: 1, name: 'Yes'),
    FoodItem(id: 2, name: 'No'),
  ];

  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  static Step16Cubit get(context) => BlocProvider.of(context);
}

class FoodItem {
  int id;
  String name;

  FoodItem({required this.id, required this.name});
}
