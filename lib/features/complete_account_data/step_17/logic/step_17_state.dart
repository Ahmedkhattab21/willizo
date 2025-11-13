abstract class Step17State {}

class InitialState extends Step17State {}
class OnChangeSelectedState extends Step17State {}
class Step17LoadingState extends Step17State {}
class Step17SuccessState extends Step17State {}
class Step17ErrorState extends Step17State {
  final String message;
  Step17ErrorState({required this.message});
}
