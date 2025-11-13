import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_20/data/models/supprotive_tool_response_model.dart';
import 'package:willizo/features/complete_account_data/step_20/data/repo/step20_repo.dart';
import 'package:willizo/features/complete_account_data/step_20/logic/step_20_state.dart';

class Step20Cubit extends Cubit<Step20State> {
  Step20Cubit(this.step20repo, this._completeAccountRepo)
    : super(InitialState());

  final Step20Repo step20repo;
  final CompleteAccountRepo _completeAccountRepo;
  SupportiveToolsData? supportiveToolsData;
  List<Equipment> supportiveTools = [];
  List<Equipment> selectedTools = [];

  static Step20Cubit get(context) => BlocProvider.of(context);

  Future<void> getSupportiveTools() async {
    emit(GetSupportiveToolsLoading());
    var result = await step20repo.getSupportiveTools();
    result.fold(
      (failure) => emit(GetSupportiveToolsError(message: failure.message)),
      (response) {
        supportiveToolsData = response.data;
        supportiveTools = response.data?.equipments ?? [];
        emit(GetSupportiveToolsSuccess());
      },
    );
  }

  void toggleTool(Equipment tool) {
    if (selectedTools.any((item) => item.id == tool.id)) {
      selectedTools.removeWhere((item) => item.id == tool.id);
    } else {
      selectedTools.add(tool);
    }
    emit(OnChangeSelectedState());
  }

  void selectAllTools() {
    if (selectedTools.length == supportiveTools.length) {
      // If all are selected, deselect all
      selectedTools.clear();
    } else {
      // Select all
      selectedTools = List.from(supportiveTools);
    }
    emit(OnChangeSelectedState());
  }

  bool isToolSelected(Equipment tool) {
    return selectedTools.any((item) => item.id == tool.id);
  }

  bool get isAllSelected {
    return supportiveTools.isNotEmpty &&
        selectedTools.length == supportiveTools.length;
  }

  Future<void> sendStep() async {
    emit(Step20LoadingState());
    final toolIds = selectedTools.map((e) => e.id).toList();
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(stepNumber: 20, supportiveToolIds: toolIds),
    );
    result.fold(
      (failure) => emit(Step20ErrorState(failure.message)),
      (data) => emit(Step20SuccessState()),
    );
  }
}
