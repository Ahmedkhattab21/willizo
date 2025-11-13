import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_18/data/models/gym_equipments_response_model.dart';
import 'package:willizo/features/complete_account_data/step_18/data/repo/step18_repo.dart';
import 'package:willizo/features/complete_account_data/step_18/logic/step_18_state.dart';

class Step18Cubit extends Cubit<Step18State> {
  Step18Cubit(this.step18repo, this._completeAccountRepo) : super(InitialState());

  Step18Repo step18repo;
  final CompleteAccountRepo _completeAccountRepo;

  List<Equipment> gymEquipments = [];
  List<Equipment> selectedEquipments = [];
  
  static Step18Cubit get(context) => BlocProvider.of(context);

  Future<void> getGymEquipments() async {
    emit(GetGymEquipmenLoadingtState());
    final result = await step18repo.getGymEquipments();
    result.fold(
      (failure) => emit(GetGymEquipmentsErrorState(failure.message)),
      (gymEquipmentsResponse) {
        gymEquipments = gymEquipmentsResponse.data?.equipments ?? [];
        emit(GetGymEquipmentsLoadedState());
      },
    );
  }

  void toggleEquipment(Equipment equipment) {
    if (selectedEquipments.any((item) => item.id == equipment.id)) {
      selectedEquipments.removeWhere((item) => item.id == equipment.id);
    } else {
      selectedEquipments.add(equipment);
    }
    emit(OnChangeSelectedState());
  }

  void selectAllEquipments() {
    if (selectedEquipments.length == gymEquipments.length) {
      // If all are selected, deselect all
      selectedEquipments.clear();
    } else {
      // Select all
      selectedEquipments = List.from(gymEquipments);
    }
    emit(OnChangeSelectedState());
  }

  bool isEquipmentSelected(Equipment equipment) {
    return selectedEquipments.any((item) => item.id == equipment.id);
  }

  bool get isAllSelected {
    return gymEquipments.isNotEmpty && 
           selectedEquipments.length == gymEquipments.length;
  }

  Future<void> sendStep() async {
    emit(Step18LoadingState());
    final equipmentIds = selectedEquipments.map((e) => e.id).toList();
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 18,
        gymEquipmentIds: equipmentIds,
      ),
    );
    result.fold(
      (failure) => emit(Step18ErrorState(failure.message)),
      (data) => emit(Step18SuccessState()),
    );
  }
}
