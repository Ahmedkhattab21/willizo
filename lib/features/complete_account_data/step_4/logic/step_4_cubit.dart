import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_4/logic/step_4_state.dart';

class Step4Cubit extends Cubit<Step4State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step4Cubit(this._completeAccountRepo) : super(InitialState());

  int selectedHeight = 100;

  onChangeSelectedHeight(int value) {
    selectedHeight = value;
    emit(OnChangeSelectedState());
  }

  Future<void> sendStep() async {
    emit(Step4LoadingState());
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 4,
        height: selectedHeight.toString(),
      ),
    );
    result.fold(
      (failure) => emit(Step4ErrorState(message: failure.message)),
      (data) => emit(Step4SuccessState()),
    );
  }

  static Step4Cubit get(context) => BlocProvider.of(context);
}
