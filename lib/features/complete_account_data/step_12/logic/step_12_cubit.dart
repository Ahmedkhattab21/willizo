import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_12/logic/step_12_state.dart';

class Step12Cubit extends Cubit<Step12State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step12Cubit(this._completeAccountRepo) : super(InitialState());

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

  Future<void> sendStep() async {
    emit(Step12LoadingState());
    final hasHealthIssues = selectedWeightId == 1;
    final healthIssues = targetWeight.text.trim().isNotEmpty ? targetWeight.text.trim() : null;
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 12,
        hasHealthIssues: hasHealthIssues,
        healthIssues: healthIssues,
      ),
    );
    result.fold(
      (failure) => emit(Step12ErrorState(message: failure.message)),
      (data) => emit(Step12SuccessState()),
    );
  }

  static Step12Cubit get(context) => BlocProvider.of(context);
}

class HealthItem {
  int id;
  String name;

  HealthItem({required this.id, required this.name});
}
