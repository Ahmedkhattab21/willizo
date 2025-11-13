abstract class Step21State {}

class InitialState extends Step21State {}
class OnChangeSelectedState extends Step21State {}
class Step21LoadingState extends Step21State {}
class Step21SuccessState extends Step21State {}
class Step21ErrorState extends Step21State {
  final String message;
  Step21ErrorState({required this.message});
}
