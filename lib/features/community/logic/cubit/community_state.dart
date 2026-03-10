part of 'community_cubit.dart';

sealed class CommunityState {}

final class CommunityInitial extends CommunityState {}

final class CommunityLoadingState extends CommunityState {}

final class CommunityLoadedState extends CommunityState {}

final class CommunityErrorState extends CommunityState {
  final Failure failure;
  CommunityErrorState(this.failure);
}

// Leaderboard states
final class LeaderboardLoadingState extends CommunityState {}

final class LeaderboardLoadedState extends CommunityState {
  final MyLeaderboardEntry? myEntry;
  final List<ExerciseCategoryEntry> exerciseCategories;
  final List<LeaderboardEntry> leaderboardFriends;
  /// Exercise details for the first card (from GET /leaderboards/exercise/:slug).
  final ExerciseInfo? firstCardExercise;
  /// Workout summary for weekly challenge (from GET /workouts/summary).
  final WorkoutSummaryModel? workoutSummary;

  LeaderboardLoadedState({
    this.myEntry,
    this.exerciseCategories = const [],
    this.leaderboardFriends = const [],
    this.firstCardExercise,
    this.workoutSummary,
  });
}

final class LeaderboardErrorState extends CommunityState {
  final Failure failure;
  LeaderboardErrorState(this.failure);
}

// Friends list states (All Friends tab)
final class FriendsLoadingState extends CommunityState {}

final class FriendsLoadedState extends CommunityState {
  final List<FriendListItem> friends;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

  FriendsLoadedState({
    required this.friends,
    required this.currentPage,
    required this.lastPage,
    required this.hasMore,
  });
}

final class FriendsLoadingMoreState extends CommunityState {
  final List<FriendListItem> friends;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

  FriendsLoadingMoreState({
    required this.friends,
    required this.currentPage,
    required this.lastPage,
    required this.hasMore,
  });
}

final class FriendsErrorState extends CommunityState {
  final Failure failure;
  FriendsErrorState(this.failure);
}

// Top followers suggestions (Suggested tab)
final class TopFollowersLoadingState extends CommunityState {}

final class TopFollowersLoadedState extends CommunityState {}

final class TopFollowersErrorState extends CommunityState {
  final Failure failure;
  TopFollowersErrorState(this.failure);
}

// Near you suggestions (Suggested tab)
final class NearYouSuggestionsLoadingState extends CommunityState {}

final class NearYouSuggestionsLoadedState extends CommunityState {}

final class NearYouSuggestionsErrorState extends CommunityState {
  final Failure failure;
  NearYouSuggestionsErrorState(this.failure);
}
final class ContactsSuggestionsLoadingState extends CommunityState {}

final class ContactsSuggestionsLoadedState extends CommunityState {}

final class ContactsSuggestionsErrorState extends CommunityState {
  final Failure failure;
  ContactsSuggestionsErrorState(this.failure);
}

// Leagues states
final class LeaguesLoadingState extends CommunityState {}

final class LeaguesLoadedState extends CommunityState {}

final class LeaguesErrorState extends CommunityState {
  final Failure failure;
  LeaguesErrorState(this.failure);
}
