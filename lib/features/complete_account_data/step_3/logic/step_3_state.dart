abstract class Step3State {}

class InitialState extends Step3State {}
class OnChangeSelectedState extends Step3State {}
class Step3LoadingState extends Step3State {}
class Step3SuccessState extends Step3State {}
class Step3ErrorState extends Step3State {
  final String message;
  Step3ErrorState({required this.message});
}
