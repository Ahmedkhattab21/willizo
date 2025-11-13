abstract class Step7State {}

class InitialState extends Step7State {}
class OnChangeSelectedState extends Step7State {}
class Step7LoadingState extends Step7State {}
class Step7SuccessState extends Step7State {}
class Step7ErrorState extends Step7State {
  final String message;
  Step7ErrorState({required this.message});
}
