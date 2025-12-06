import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_8/logic/step_8_state.dart';

class Step8Cubit extends Cubit<Step8State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step8Cubit(this._completeAccountRepo) : super(InitialState());

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

  bool get isValid {
    return selectedItems.isNotEmpty;
  }

  Future<void> sendStep() async {
    emit(Step8LoadingState());
    final days = selectedItems.map((item) => item.name).toList();
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 8,
        days: days,
      ),
    );
    result.fold(
      (failure) => emit(Step8ErrorState(message: failure.message)),
      (data) => emit(Step8SuccessState()),
    );
  }

  static Step8Cubit get(context) => BlocProvider.of(context);
}

class DayItem {
  int id;
  String name;

  DayItem({required this.id, required this.name});
}
