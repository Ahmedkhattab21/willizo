abstract class Step16State {}

class InitialState extends Step16State {}
class OnChangeSelectedState extends Step16State {}
class Step16LoadingState extends Step16State {}
class Step16SuccessState extends Step16State {}
class Step16ErrorState extends Step16State {
  final String message;
  Step16ErrorState({required this.message});
}
