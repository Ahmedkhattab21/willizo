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

final class FriendsStatsLoadingState extends CommunityState {}

final class FriendsStatsLoadedState extends CommunityState {}

final class FriendsStatsErrorState extends CommunityState {
  final Failure failure;
  FriendsStatsErrorState(this.failure);
}

final class FriendRequestsLoadingState extends CommunityState {}

final class FriendRequestsLoadedState extends CommunityState {
  final List<FriendListItem> requests;

  FriendRequestsLoadedState(this.requests);
}

final class FriendRequestsErrorState extends CommunityState {
  final Failure failure;
  FriendRequestsErrorState(this.failure);
}

final class FriendRequestActionLoadingState extends CommunityState {
  final String requestId;

  FriendRequestActionLoadingState(this.requestId);
}

final class FriendRequestActionErrorState extends CommunityState {
  final String requestId;
  final Failure failure;

  FriendRequestActionErrorState({
    required this.requestId,
    required this.failure,
  });
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

// Available leagues states
final class AvailableLeaguesLoadingState extends CommunityState {}

final class AvailableLeaguesLoadedState extends CommunityState {}

final class AvailableLeaguesErrorState extends CommunityState {
  final Failure failure;
  AvailableLeaguesErrorState(this.failure);
}

// Create league states
final class LeagueCreatingState extends CommunityState {}

final class LeagueCreatedState extends CommunityState {}

final class LeagueCreationErrorState extends CommunityState {
  final Failure failure;
  LeagueCreationErrorState(this.failure);
}

// Feeds states
final class FeedsLoadingState extends CommunityState {}

final class FeedsLoadedState extends CommunityState {}

final class FeedsErrorState extends CommunityState {
  final Failure failure;
  FeedsErrorState(this.failure);
}

// Create post states
final class PostCreatingState extends CommunityState {}

final class PostCreatedState extends CommunityState {}

final class PostCreationErrorState extends CommunityState {
  final Failure failure;
  PostCreationErrorState(this.failure);
}

// Join league states
final class LeagueJoiningState extends CommunityState {}

final class LeagueJoinedState extends CommunityState {}

final class LeagueJoinErrorState extends CommunityState {
  final Failure failure;
  LeagueJoinErrorState(this.failure);
}
