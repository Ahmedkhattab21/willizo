import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_7/logic/step_7_state.dart';

class Step7Cubit extends Cubit<Step7State> {
  Step7Cubit() : super(InitialState());

  List<GoalItem> items = [
    GoalItem(id: 1, name: 'Build muscle mass'),
    GoalItem(id: 2, name: 'Lose Weight'),
    GoalItem(id: 3, name: 'Burn fat and lose excess weight'),
    GoalItem(id: 4, name: 'Increase stamina'),
    GoalItem(id: 5, name: 'Maintain overall health'),
    GoalItem(id: 6, name: 'Enhance appearance'),
    GoalItem(id: 7, name: 'Stick to a long-term healthy'),
  ];

  List<GoalItem> selectedItems = [];

  onAddItem(GoalItem value) {
    selectedItems.add(value);
    emit(OnChangeSelectedState());
  }

  onDeleteItem(GoalItem value) {
    selectedItems.removeWhere((test) => test.id == value.id);
    emit(OnChangeSelectedState());
  }

   addOrDeleteItem(GoalItem value) {
    bool isFoundItem = selectedItems.any((item) => item.id == value.id);
    if (isFoundItem) {
      onDeleteItem(value);
    } else {
      onAddItem(value);
    }
  }

  bool containItem(GoalItem value) {
    return selectedItems.any((item) => item.id == value.id);
  }

  static Step7Cubit get(context) => BlocProvider.of(context);
}

class GoalItem {
  int id;
  String name;

  GoalItem({required this.id, required this.name});
}
