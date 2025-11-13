abstract class Step14State {}

class InitialState extends Step14State {}
class OnChangeSelectedState extends Step14State {}
class Step14LoadingState extends Step14State {}
class Step14SuccessState extends Step14State {}
class Step14ErrorState extends Step14State {
  final String message;
  Step14ErrorState({required this.message});
}
