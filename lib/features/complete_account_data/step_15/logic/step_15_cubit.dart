import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_15/logic/step_15_state.dart';

class Step15Cubit extends Cubit<Step15State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step15Cubit(this._completeAccountRepo) : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<AllergicItem> yesAndNo = [
    AllergicItem(id: 1, name: 'Yes'),
    AllergicItem(id: 2, name: 'No'),
  ];

  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  Future<void> sendStep() async {
    emit(Step15LoadingState());
    final goal = yesAndNo.firstWhere((item) => item.id == selectedWeightId).name;
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 15,
        goal: goal,
      ),
    );
    result.fold(
      (failure) => emit(Step15ErrorState(message: failure.message)),
      (data) => emit(Step15SuccessState()),
    );
  }

  static Step15Cubit get(context) => BlocProvider.of(context);
}

class AllergicItem {
  int id;
  String name;

  AllergicItem({required this.id, required this.name});
}
