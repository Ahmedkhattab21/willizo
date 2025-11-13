import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_2/logic/step_2_state.dart';

class Step2Cubit extends Cubit<Step2State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step2Cubit(this._completeAccountRepo) : super(InitialState());

  GlobalKey<FormState> key = GlobalKey<FormState>();

  TextEditingController ageController = TextEditingController();

  Future<void> sendStep() async {
    emit(Step2LoadingState());
    final age = int.tryParse(ageController.text.trim());
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 2,
        age: age,
      ),
    );
    result.fold(
      (failure) => emit(Step2ErrorState(message: failure.message)),
      (data) => emit(Step2SuccessState()),
    );
  }

  static Step2Cubit get(context) => BlocProvider.of(context);
}
