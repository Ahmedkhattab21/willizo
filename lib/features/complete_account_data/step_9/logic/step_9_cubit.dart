import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_9/logic/step_9_state.dart';

class Step9Cubit extends Cubit<Step9State> {
  Step9Cubit() : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<LevelItem> levelsItems = [
    LevelItem(id: 1, name: 'Beginner'),
    LevelItem(id: 2, name: 'Intermediate'),
    LevelItem(id: 3, name: 'Advanced'),
  ];
  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  static Step9Cubit get(context) => BlocProvider.of(context);
}

class LevelItem {
  int id;
  String name;

  LevelItem({required this.id, required this.name});
}
