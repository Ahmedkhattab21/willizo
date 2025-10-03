import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_19/logic/step_19_state.dart';

class Step19Cubit extends Cubit<Step19State> {
  Step19Cubit() : super(InitialState());




  static Step19Cubit get(context) => BlocProvider.of(context);
}

