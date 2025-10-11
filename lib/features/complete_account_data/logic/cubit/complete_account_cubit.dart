import 'package:bloc/bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';

part 'complete_account_state.dart';

class CompleteAccountCubit extends Cubit<CompleteAccountState> {
  CompleteAccountCubit(this.completeAccountRepo)
    : super(CompleteAccountInitial());

  final CompleteAccountRepo completeAccountRepo;

  Future<void> sendSteps({required StepsRequestModel parameter}) async {
    emit(CompleteAccountLoading());
    final result = await completeAccountRepo.sendSteps(parameter: parameter);
    result.fold(
      (failure) => emit(CompleteAccountError(message: failure.message)),
      (response) => emit(CompleteAccountSuccess()),
    );
  }
}
