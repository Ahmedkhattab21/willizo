abstract class Step15State {}

class InitialState extends Step15State {}
class OnChangeSelectedState extends Step15State {}
class Step15LoadingState extends Step15State {}
class Step15SuccessState extends Step15State {}
class Step15ErrorState extends Step15State {
  final String message;
  Step15ErrorState({required this.message});
}
