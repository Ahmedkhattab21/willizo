import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_14/logic/step_14_state.dart';

class Step14Cubit extends Cubit<Step14State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step14Cubit(this._completeAccountRepo) : super(InitialState());

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

  bool get isValid {
    // If "Yes" is selected, at least one diet item must be selected
    if (selectedWeightId == 1) {
      return selectedItems.isNotEmpty;
    }
    // If "No" is selected, validation passes
    return true;
  }

  Future<void> sendStep() async {
    emit(Step14LoadingState());
    final hasDietry = selectedWeightId == 1;
    final chooseFromFollowingIfHasDietryIssues = selectedItems.isNotEmpty 
        ? selectedItems.map((item) => item.name).join(', ') 
        : null;
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 14,
        hasDietry: hasDietry,
        chooseFromFollowingIfHasDietryIssues: chooseFromFollowingIfHasDietryIssues,
      ),
    );
    result.fold(
      (failure) => emit(Step14ErrorState(message: failure.message)),
      (data) => emit(Step14SuccessState()),
    );
  }

  static Step14Cubit get(context) => BlocProvider.of(context);
}

class DietItem {
  int id;
  String name;

  DietItem({required this.id, required this.name});
}
