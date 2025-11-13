import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_5/logic/step_5_state.dart';

class Step5Cubit extends Cubit<Step5State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step5Cubit(this._completeAccountRepo) : super(InitialState());

  int selectedKilo = 100;

  onChangeSelectedKilo(int value) {
    selectedKilo = value;
    emit(OnChangeSelectedKiloState());
  }

  int selectedGram = 10;

  onChangeSelectedGram(int value) {
    selectedGram = value;
    emit(OnChangeSelectedGramState());
  }

  Future<void> sendStep() async {
    emit(Step5LoadingState());
    final weight = '$selectedKilo.${selectedGram.toString().padLeft(2, '0')}';
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 5,
        weight: weight,
      ),
    );
    result.fold(
      (failure) => emit(Step5ErrorState(message: failure.message)),
      (data) => emit(Step5SuccessState()),
    );
  }

  static Step5Cubit get(context) => BlocProvider.of(context);
}
