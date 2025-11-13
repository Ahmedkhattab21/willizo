import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_1/logic/step_1_state.dart';

class Step1Cubit extends Cubit<Step1State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step1Cubit(this._completeAccountRepo) : super(InitialState());

  GlobalKey<FormState> key = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  Future<void> sendStep() async {
    emit(Step1LoadingState());
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 1,
        name: nameController.text.trim(),
      ),
    );
    result.fold(
      (failure) => emit(Step1ErrorState(message: failure.message)),
      (data) => emit(Step1SuccessState()),
    );
  }

  static Step1Cubit get(context) => BlocProvider.of(context);
}
