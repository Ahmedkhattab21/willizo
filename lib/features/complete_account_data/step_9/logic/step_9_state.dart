abstract class Step9State {}

class InitialState extends Step9State {}
class OnChangeSelectedState extends Step9State {}
class Step9LoadingState extends Step9State {}
class Step9SuccessState extends Step9State {}
class Step9ErrorState extends Step9State {
  final String message;
  Step9ErrorState({required this.message});
}
