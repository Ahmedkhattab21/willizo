import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_11/logic/step_11_state.dart';

class Step11Cubit extends Cubit<Step11State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step11Cubit(this._completeAccountRepo) : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<ActiveItem> activeItems = [
    ActiveItem(id: 1, name: 'Very active'),
    ActiveItem(id: 2, name: 'Moderately active'),
    ActiveItem(id: 3, name: 'Not very active'),
    ActiveItem(id: 4, name: 'Inactive'),
  ];
  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  Future<void> sendStep() async {
    emit(Step11LoadingState());
    final activeLevel = activeItems.firstWhere((item) => item.id == selectedWeightId).name;
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 11,
        activeLevel: activeLevel,
      ),
    );
    result.fold(
      (failure) => emit(Step11ErrorState(message: failure.message)),
      (data) => emit(Step11SuccessState()),
    );
  }

  static Step11Cubit get(context) => BlocProvider.of(context);
}

class ActiveItem {
  int id;
  String name;

  ActiveItem({required this.id, required this.name});
}
