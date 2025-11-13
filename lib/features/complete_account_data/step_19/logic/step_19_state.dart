abstract class Step19State {}

class InitialState extends Step19State {}
class GetFreeWeightsLoading extends Step19State {}
class GetFreeWeightsSuccess extends Step19State {}
class GetFreeWeightsError extends Step19State {
  final String message;
  GetFreeWeightsError({required this.message});
}

class OnChangeSelectedState extends Step19State {}

class Step19LoadingState extends Step19State {}
class Step19SuccessState extends Step19State {}
class Step19ErrorState extends Step19State {
  final String message;
  Step19ErrorState(this.message);
}