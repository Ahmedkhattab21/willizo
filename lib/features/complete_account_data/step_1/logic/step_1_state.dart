abstract class Step1State {}

class InitialState extends Step1State {}
class OnChangeSignInState extends Step1State {}
class OnChangeAgreeForTermsState extends Step1State {}
class Step1LoadingState extends Step1State {}
class Step1SuccessState extends Step1State {}
class Step1ErrorState extends Step1State {
  final String message;
  Step1ErrorState({required this.message});
}
