import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_13/logic/step_13_state.dart';

class Step13Cubit extends Cubit<Step13State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step13Cubit(this._completeAccountRepo) : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<TimeITem> timesItems = [
    TimeITem(id: 1, name: 'Morning'),
    TimeITem(id: 2, name: 'After noon'),
    TimeITem(id: 3, name: 'Night'),
  ];
  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  Future<void> sendStep() async {
    emit(Step13LoadingState());
    final betTimeForWorkout = timesItems.firstWhere((item) => item.id == selectedWeightId).name;
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 13,
        betTimeForWorkout: betTimeForWorkout,
      ),
    );
    result.fold(
      (failure) => emit(Step13ErrorState(message: failure.message)),
      (data) => emit(Step13SuccessState()),
    );
  }

  static Step13Cubit get(context) => BlocProvider.of(context);
}

class TimeITem {
  int id;
  String name;

  TimeITem({required this.id, required this.name});
}
