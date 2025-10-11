part of 'account_cubit.dart';

sealed class AccountState {}

final class AccountInitial extends AccountState {}

final class FetchAccountLoadingState extends AccountState {}

final class FetchAccountLoadedState extends AccountState {}

final class FetchAccountErrorState extends AccountState {
  final String message;

  FetchAccountErrorState({required this.message});
}
