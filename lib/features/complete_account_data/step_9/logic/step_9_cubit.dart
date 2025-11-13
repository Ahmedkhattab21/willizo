import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_9/logic/step_9_state.dart';

class Step9Cubit extends Cubit<Step9State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step9Cubit(this._completeAccountRepo) : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<LevelItem> levelsItems = [
    LevelItem(id: 1, name: 'Beginner'),
    LevelItem(id: 2, name: 'Intermediate'),
    LevelItem(id: 3, name: 'Advanced'),
  ];
  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  Future<void> sendStep() async {
    emit(Step9LoadingState());
    final level = levelsItems.firstWhere((item) => item.id == selectedWeightId).name;
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 9,
        level: level,
      ),
    );
    result.fold(
      (failure) => emit(Step9ErrorState(message: failure.message)),
      (data) => emit(Step9SuccessState()),
    );
  }

  static Step9Cubit get(context) => BlocProvider.of(context);
}

class LevelItem {
  int id;
  String name;

  LevelItem({required this.id, required this.name});
}
