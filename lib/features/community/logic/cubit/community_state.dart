part of 'community_cubit.dart';

sealed class CommunityState {}

final class CommunityInitial extends CommunityState {}

final class CommunityLoadingState extends CommunityState {}

final class CommunityLoadedState extends CommunityState {}

final class CommunityErrorState extends CommunityState {
  final Failure failure;
  CommunityErrorState(this.failure);
}
