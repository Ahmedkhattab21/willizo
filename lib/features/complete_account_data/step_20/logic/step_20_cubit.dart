import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_20/logic/step_20_state.dart';

class Step20Cubit extends Cubit<Step20State> {
  Step20Cubit() : super(InitialState());




  static Step20Cubit get(context) => BlocProvider.of(context);
}

