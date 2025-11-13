abstract class Step13State {}

class InitialState extends Step13State {}
class OnChangeSelectedState extends Step13State {}
class Step13LoadingState extends Step13State {}
class Step13SuccessState extends Step13State {}
class Step13ErrorState extends Step13State {
  final String message;
  Step13ErrorState({required this.message});
}
