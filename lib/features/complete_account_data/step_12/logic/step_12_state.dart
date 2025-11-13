abstract class Step12State {}

class InitialState extends Step12State {}
class OnChangeSelectedState extends Step12State {}
class Step12LoadingState extends Step12State {}
class Step12SuccessState extends Step12State {}
class Step12ErrorState extends Step12State {
  final String message;
  Step12ErrorState({required this.message});
}
