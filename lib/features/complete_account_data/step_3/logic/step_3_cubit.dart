import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_3/logic/step_3_state.dart';

class Step3Cubit extends Cubit<Step3State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step3Cubit(this._completeAccountRepo) : super(InitialState());

  List<GenderItem> genders = [
    GenderItem(id: 1, name: 'Male'),
    GenderItem(id: 2, name: 'Female'),
  ];

  int selectedGender = 1;

  changeSelectedGender(int value) {
    selectedGender = value;
    emit(OnChangeSelectedState());
  }

  Future<void> sendStep() async {
    emit(Step3LoadingState());
    final gender = genders.firstWhere((item) => item.id == selectedGender).name;
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 3,
        gender: gender,
      ),
    );
    result.fold(
      (failure) => emit(Step3ErrorState(message: failure.message)),
      (data) => emit(Step3SuccessState()),
    );
  }

  static Step3Cubit get(context) => BlocProvider.of(context);
}

class GenderItem {
  int id;
  String name;

  GenderItem({required this.id, required this.name});
}
