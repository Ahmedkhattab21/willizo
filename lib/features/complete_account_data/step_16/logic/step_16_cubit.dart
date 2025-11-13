import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_16/logic/step_16_state.dart';

class Step16Cubit extends Cubit<Step16State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step16Cubit(this._completeAccountRepo) : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<FoodItem> yesAndNo = [
    FoodItem(id: 1, name: 'Yes'),
    FoodItem(id: 2, name: 'No'),
  ];

  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  Future<void> sendStep() async {
    emit(Step16LoadingState());
    final isAllergic = selectedWeightId == 1;
    final healthIssuesDescription = targetWeight.text.trim().isNotEmpty ? targetWeight.text.trim() : null;
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 16,
        isAllergic: isAllergic,
        healthIssuesDescription: healthIssuesDescription,
      ),
    );
    result.fold(
      (failure) => emit(Step16ErrorState(message: failure.message)),
      (data) => emit(Step16SuccessState()),
    );
  }

  static Step16Cubit get(context) => BlocProvider.of(context);
}

class FoodItem {
  int id;
  String name;

  FoodItem({required this.id, required this.name});
}
