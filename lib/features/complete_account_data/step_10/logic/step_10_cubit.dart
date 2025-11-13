import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_10/logic/step_10_state.dart';

class Step10Cubit extends Cubit<Step10State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step10Cubit(this._completeAccountRepo) : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<WorkOutItem> levelsItems = [
    WorkOutItem(id: 1, name: 'Gym'),
    WorkOutItem(id: 2, name: 'Home'),
    WorkOutItem(id: 3, name: 'Out Side'),
  ];
  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  Future<void> sendStep() async {
    emit(Step10LoadingState());
    final workout = levelsItems.firstWhere((item) => item.id == selectedWeightId).name;
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 10,
        workout: workout,
      ),
    );
    result.fold(
      (failure) => emit(Step10ErrorState(message: failure.message)),
      (data) => emit(Step10SuccessState()),
    );
  }

  static Step10Cubit get(context) => BlocProvider.of(context);
}

class WorkOutItem {
  int id;
  String name;

  WorkOutItem({required this.id, required this.name});
}
