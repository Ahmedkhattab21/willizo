import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_6/logic/step_6_state.dart';

class Step6Cubit extends Cubit<Step6State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step6Cubit(this._completeAccountRepo) : super(InitialState());

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

  Future<void> sendStep() async {
    emit(Step6LoadingState());
    final hasTargetWeight = selectedWeightId == 1;
    final targetWeightValue = int.tryParse(targetWeight.text.trim());
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 6,
        hasTargetWeight: hasTargetWeight,
        targetWeight: targetWeightValue,
      ),
    );
    result.fold(
      (failure) => emit(Step6ErrorState(message: failure.message)),
      (data) => emit(Step6SuccessState()),
    );
  }

  static Step6Cubit get(context) => BlocProvider.of(context);
}

class BoolItem {
  int id;
  String name;

  BoolItem({required this.id, required this.name});
}
