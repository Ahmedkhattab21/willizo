abstract class Step6State {}

class InitialState extends Step6State {}
class OnChangeSelectedState extends Step6State {}
class Step6LoadingState extends Step6State {}
class Step6SuccessState extends Step6State {}
class Step6ErrorState extends Step6State {
  final String message;
  Step6ErrorState({required this.message});
}
