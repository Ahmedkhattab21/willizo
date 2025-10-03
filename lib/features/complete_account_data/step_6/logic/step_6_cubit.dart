import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_6/logic/step_6_state.dart';

class Step6Cubit extends Cubit<Step6State> {
  Step6Cubit() : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<BoolItem> yesAndNo = [
    BoolItem(id: 1, name: 'Yes'),
    BoolItem(id: 2, name: 'No'),
  ];

  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  static Step6Cubit get(context) => BlocProvider.of(context);
}

class BoolItem {
  int id;
  String name;

  BoolItem({required this.id, required this.name});
}
