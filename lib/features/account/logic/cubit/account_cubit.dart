import 'package:bloc/bloc.dart';
import 'package:willizo/features/account/data/models/account_resonse.dart';
import 'package:willizo/features/account/data/repo/account_repo.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._accountRepo) : super(AccountInitial());
  final AccountRepo _accountRepo;

  Future<void> getAccountData() async {
    emit(FetchAccountLoadingState());
    final result = await _accountRepo.getAccountData();
    result.fold(
      (failure) => emit(FetchAccountErrorState(message: failure.message)),
      (data) => emit(FetchAccountLoadedState(accountData: data)),
    );
  }
}
