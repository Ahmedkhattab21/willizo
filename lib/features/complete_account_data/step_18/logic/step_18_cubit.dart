import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_18/logic/step_18_state.dart';

class Step18Cubit extends Cubit<Step18State> {
  Step18Cubit() : super(InitialState());




  static Step18Cubit get(context) => BlocProvider.of(context);
}

