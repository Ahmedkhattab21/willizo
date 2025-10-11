part of 'complete_account_cubit.dart';

sealed class CompleteAccountState {}

final class CompleteAccountInitial extends CompleteAccountState {}

final class CompleteAccountLoading extends CompleteAccountState {}

final class CompleteAccountError extends CompleteAccountState {
  final String message;
   CompleteAccountError({required this.message});
}

final class CompleteAccountSuccess extends CompleteAccountState {}
