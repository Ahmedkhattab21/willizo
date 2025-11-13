abstract class Step11State {}

class InitialState extends Step11State {}
class OnChangeSelectedState extends Step11State {}
class Step11LoadingState extends Step11State {}
class Step11SuccessState extends Step11State {}
class Step11ErrorState extends Step11State {
  final String message;
  Step11ErrorState({required this.message});
}
