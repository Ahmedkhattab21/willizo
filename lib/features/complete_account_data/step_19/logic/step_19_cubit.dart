import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_19/data/models/free_weight_response_model.dart';
import 'package:willizo/features/complete_account_data/step_19/data/repo/step19_repo.dart';
import 'package:willizo/features/complete_account_data/step_19/logic/step_19_state.dart';

class Step19Cubit extends Cubit<Step19State> {
  Step19Cubit(this.step19Repo, this._completeAccountRepo) : super(InitialState());

  final Step19Repo step19Repo;
  final CompleteAccountRepo _completeAccountRepo;
  FreeWeightsData? freeWeightsData;
  List<Equipment> freeWeights = [];
  List<Equipment> selectedWeights = [];
  
  static Step19Cubit get(context) => BlocProvider.of(context);

  Future<void> getFreeWeights() async {
    emit(GetFreeWeightsLoading());
    final result = await step19Repo.getFreeWeights();
    result.fold(
      (failure) => emit(GetFreeWeightsError(message: failure.message)),
      (freeWeightsData) {
        this.freeWeightsData = freeWeightsData.data;
        freeWeights = freeWeightsData.data?.equipments ?? [];
        emit(GetFreeWeightsSuccess());
      },
    );
  }

  void toggleWeight(Equipment weight) {
    if (selectedWeights.any((item) => item.id == weight.id)) {
      selectedWeights.removeWhere((item) => item.id == weight.id);
    } else {
      selectedWeights.add(weight);
    }
    emit(OnChangeSelectedState());
  }

  void selectAllWeights() {
    if (selectedWeights.length == freeWeights.length) {
      // If all are selected, deselect all
      selectedWeights.clear();
    } else {
      // Select all
      selectedWeights = List.from(freeWeights);
    }
    emit(OnChangeSelectedState());
  }

  bool isWeightSelected(Equipment weight) {
    return selectedWeights.any((item) => item.id == weight.id);
  }

  bool get isAllSelected {
    return freeWeights.isNotEmpty && 
           selectedWeights.length == freeWeights.length;
  }

  bool get isValid {
    return selectedWeights.isNotEmpty;
  }

  Future<void> sendStep() async {
    emit(Step19LoadingState());
    final weightIds = selectedWeights.map((e) => e.id).toList();
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 19,
        freeWeightIds: weightIds,
      ),
    );
    result.fold(
      (failure) => emit(Step19ErrorState(failure.message)),
      (data) => emit(Step19SuccessState()),
    );
  }
}
