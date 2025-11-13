abstract class Step10State {}

class InitialState extends Step10State {}
class OnChangeSelectedState extends Step10State {}
class Step10LoadingState extends Step10State {}
class Step10SuccessState extends Step10State {}
class Step10ErrorState extends Step10State {
  final String message;
  Step10ErrorState({required this.message});
}
