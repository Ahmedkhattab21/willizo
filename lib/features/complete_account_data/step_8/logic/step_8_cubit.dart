import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_8/logic/step_8_state.dart';

class Step8Cubit extends Cubit<Step8State> {
  Step8Cubit() : super(InitialState());

  List<DayItem> items = [
    DayItem(id: 1, name: 'Monday'),
    DayItem(id: 2, name: 'Tuesday'),
    DayItem(id: 3, name: 'Wednesday'),
    DayItem(id: 4, name: 'Thursday'),
    DayItem(id: 5, name: 'Friday'),
    DayItem(id: 6, name: 'Saturday'),
    DayItem(id: 7, name: 'Sunday'),
  ];

  List<DayItem> selectedItems = [];

  onAddItem(DayItem value) {
    selectedItems.add(value);
    emit(OnChangeSelectedState());
  }

  onDeleteItem(DayItem value) {
    selectedItems.removeWhere((test) => test.id == value.id);
    emit(OnChangeSelectedState());
  }

  addOrDeleteItem(DayItem value) {
    bool isFoundItem = selectedItems.any((item) => item.id == value.id);
    if (isFoundItem) {
      onDeleteItem(value);
    } else {
      onAddItem(value);
    }
  }

  bool containItem(DayItem value) {
    return selectedItems.any((item) => item.id == value.id);
  }

  static Step8Cubit get(context) => BlocProvider.of(context);
}

class DayItem {
  int id;
  String name;

  DayItem({required this.id, required this.name});
}
