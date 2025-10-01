
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/onboarding/logic/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {

  OnboardingCubit() : super(InitialState());
  int onBoardingPage=1;
  changeOnBoardingPage(int value){
    onBoardingPage=value;
    emit(OnChangeOnBoardingState());
  }

  static OnboardingCubit get(context) => BlocProvider.of(context);
}
