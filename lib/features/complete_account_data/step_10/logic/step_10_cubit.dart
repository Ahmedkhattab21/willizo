import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_10/logic/step_10_state.dart';

class Step10Cubit extends Cubit<Step10State> {
  Step10Cubit() : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<WorkOutItem> levelsItems = [
    WorkOutItem(id: 1, name: 'Gym'),
    WorkOutItem(id: 2, name: 'Home'),
    WorkOutItem(id: 3, name: 'Out Side'),
  ];
  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  static Step10Cubit get(context) => BlocProvider.of(context);
}

class WorkOutItem {
  int id;
  String name;

  WorkOutItem({required this.id, required this.name});
}
