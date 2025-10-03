import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_14/logic/step_14_state.dart';

class Step14Cubit extends Cubit<Step14State> {
  Step14Cubit() : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<DietItem> yesAndNo = [
    DietItem(id: 1, name: 'Yes'),
    DietItem(id: 2, name: 'No'),
  ];

  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }




  List<DietItem> dietItemItems = [
    DietItem(id: 1, name: 'Yes, I follow a vegetarian diet.'),
    DietItem(id: 2, name: 'Yes, I’m lactose intolerant'),
    DietItem(id: 3, name: 'Yes, I avoid nuts because I’m allergic.'),
  ];

  List<DietItem> selectedItems = [];

  onAddItem(DietItem value) {
    selectedItems.add(value);
    emit(OnChangeSelectedState());
  }

  onDeleteItem(DietItem value) {
    selectedItems.removeWhere((test) => test.id == value.id);
    emit(OnChangeSelectedState());
  }

  addOrDeleteItem(DietItem value) {
    bool isFoundItem = selectedItems.any((item) => item.id == value.id);
    if (isFoundItem) {
      onDeleteItem(value);
    } else {
      onAddItem(value);
    }
  }

  bool containItem(DietItem value) {
    return selectedItems.any((item) => item.id == value.id);
  }


  static Step14Cubit get(context) => BlocProvider.of(context);
}

class DietItem {
  int id;
  String name;

  DietItem({required this.id, required this.name});
}
