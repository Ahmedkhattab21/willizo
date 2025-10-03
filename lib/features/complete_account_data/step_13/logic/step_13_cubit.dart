import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_13/logic/step_13_state.dart';

class Step13Cubit extends Cubit<Step13State> {
  Step13Cubit() : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<TimeITem> timesItems = [
    TimeITem(id: 1, name: 'Morning'),
    TimeITem(id: 2, name: 'After noon'),
    TimeITem(id: 3, name: 'Night'),
  ];
  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  static Step13Cubit get(context) => BlocProvider.of(context);
}

class TimeITem {
  int id;
  String name;

  TimeITem({required this.id, required this.name});
}
