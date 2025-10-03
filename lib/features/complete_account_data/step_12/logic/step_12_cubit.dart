import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_12/logic/step_12_state.dart';

class Step12Cubit extends Cubit<Step12State> {
  Step12Cubit() : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<HealthItem> yesAndNo = [
    HealthItem(id: 1, name: 'Yes'),
    HealthItem(id: 2, name: 'No'),
  ];

  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  static Step12Cubit get(context) => BlocProvider.of(context);
}

class HealthItem {
  int id;
  String name;

  HealthItem({required this.id, required this.name});
}
