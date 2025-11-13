abstract class Step20State {}

class InitialState extends Step20State {}
class GetSupportiveToolsLoading extends Step20State {}
class GetSupportiveToolsSuccess extends Step20State {}
class GetSupportiveToolsError extends Step20State {
  final String message;
  GetSupportiveToolsError({required this.message});
}

class OnChangeSelectedState extends Step20State {}

class Step20LoadingState extends Step20State {}
class Step20SuccessState extends Step20State {}
class Step20ErrorState extends Step20State {
  final String message;
  Step20ErrorState(this.message);
}