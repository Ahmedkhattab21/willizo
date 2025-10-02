import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/complete_account_data/step_2/logic/step_2_state.dart';

class Step2Cubit extends Cubit<Step2State> {
  Step2Cubit() : super(InitialState());

  GlobalKey<FormState> key = GlobalKey<FormState>();

  TextEditingController ageController = TextEditingController();

  static Step2Cubit get(context) => BlocProvider.of(context);
}
