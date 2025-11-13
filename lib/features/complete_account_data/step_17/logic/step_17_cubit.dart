import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_17/logic/step_17_state.dart';

class Step17Cubit extends Cubit<Step17State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step17Cubit(this._completeAccountRepo) : super(InitialState());

  TextEditingController targetWeight = TextEditingController();

  List<MealItem> mealItems = [
    MealItem(id: 1, name: '2 meals'),
    MealItem(id: 2, name: '3 meals'),
    MealItem(id: 3, name: '4 meals'),
    MealItem(id: 4, name: '5 meals'),
    MealItem(id: 5, name: '6 meals'),
  ];
  int selectedWeightId = 1;

  changeSelectedWeightId(int value) {
    selectedWeightId = value;
    emit(OnChangeSelectedState());
  }

  Future<void> sendStep() async {
    emit(Step17LoadingState());
    final selectedMeal = mealItems.firstWhere((item) => item.id == selectedWeightId);
    final mealsPerDay = int.tryParse(selectedMeal.name.split(' ').first);
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 17,
        mealsPerDay: mealsPerDay,
      ),
    );
    result.fold(
      (failure) => emit(Step17ErrorState(message: failure.message)),
      (data) => emit(Step17SuccessState()),
    );
  }

  static Step17Cubit get(context) => BlocProvider.of(context);
}

class MealItem {
  int id;
  String name;

  MealItem({required this.id, required this.name});
}
