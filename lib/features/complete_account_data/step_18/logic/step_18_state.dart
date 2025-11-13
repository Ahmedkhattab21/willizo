abstract class Step18State {}

class InitialState extends Step18State {}

class GetGymEquipmenLoadingtState extends Step18State {}

class GetGymEquipmentsLoadedState extends Step18State {}

class GetGymEquipmentsErrorState extends Step18State {
  final String error;
  GetGymEquipmentsErrorState(this.error);
}

class OnChangeSelectedState extends Step18State {}

class Step18LoadingState extends Step18State {}
class Step18SuccessState extends Step18State {}
class Step18ErrorState extends Step18State {
  final String message;
  Step18ErrorState(this.message);
}