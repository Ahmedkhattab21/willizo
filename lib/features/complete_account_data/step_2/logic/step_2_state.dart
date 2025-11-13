abstract class Step2State {}

class InitialState extends Step2State {}
class OnChangeSignInState extends Step2State {}
class OnChangeAgreeForTermsState extends Step2State {}
class Step2LoadingState extends Step2State {}
class Step2SuccessState extends Step2State {}
class Step2ErrorState extends Step2State {
  final String message;
  Step2ErrorState({required this.message});
}
