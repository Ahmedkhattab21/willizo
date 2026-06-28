part of 'account_cubit.dart';

sealed class AccountState {}

final class AccountInitial extends AccountState {}

enum AccountActionType { logout, removeAccount }

final class FetchAccountLoadingState extends AccountState {}

final class FetchAccountLoadedState extends AccountState {
  final AccountResponseModel accountData;

  FetchAccountLoadedState({required this.accountData});
}

final class FetchAccountErrorState extends AccountState {
  final String message;

  FetchAccountErrorState({required this.message});
}

final class AccountActionLoadingState extends AccountState {
  final AccountResponseModel? accountData;
  final AccountActionType actionType;

  AccountActionLoadingState({required this.actionType, this.accountData});
}

final class AccountActionSuccessState extends AccountState {
  final String message;
  final AccountActionType actionType;

  AccountActionSuccessState({required this.message, required this.actionType});
}

final class AccountActionErrorState extends AccountState {
  final String message;
  final AccountResponseModel? accountData;

  AccountActionErrorState({required this.message, this.accountData});
}
