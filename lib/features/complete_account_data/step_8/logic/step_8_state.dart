abstract class Step8State {}

class InitialState extends Step8State {}
class OnChangeSelectedState extends Step8State {}
class Step8LoadingState extends Step8State {}
class Step8SuccessState extends Step8State {}
class Step8ErrorState extends Step8State {
  final String message;
  Step8ErrorState({required this.message});
}
