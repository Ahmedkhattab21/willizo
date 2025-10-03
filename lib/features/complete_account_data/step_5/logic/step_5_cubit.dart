import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_5/logic/step_5_state.dart';

class Step5Cubit extends Cubit<Step5State> {
  Step5Cubit() : super(InitialState());

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

  static Step5Cubit get(context) => BlocProvider.of(context);
}
