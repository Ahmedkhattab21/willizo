abstract class Step4State {}

class InitialState extends Step4State {}
class OnChangeSelectedState extends Step4State {}
class Step4LoadingState extends Step4State {}
class Step4SuccessState extends Step4State {}
class Step4ErrorState extends Step4State {
  final String message;
  Step4ErrorState({required this.message});
}
