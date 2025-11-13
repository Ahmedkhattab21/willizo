abstract class Step5State {}

class InitialState extends Step5State {}
class OnChangeSelectedKiloState extends Step5State {}
class OnChangeSelectedGramState extends Step5State {}
class Step5LoadingState extends Step5State {}
class Step5SuccessState extends Step5State {}
class Step5ErrorState extends Step5State {
  final String message;
  Step5ErrorState({required this.message});
}
