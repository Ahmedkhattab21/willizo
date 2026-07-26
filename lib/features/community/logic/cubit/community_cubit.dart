import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/community/data/models/exercise_category_model.dart';
import 'package:willizo/features/community/data/models/create_league_request_model.dart';
import 'package:willizo/features/community/data/models/feed_model.dart';
import 'package:willizo/features/community/data/models/league_model.dart';
import 'package:willizo/features/community/data/models/friend_model.dart';
import 'package:willizo/features/community/data/models/leaderboard_model.dart';
import 'package:willizo/features/community/data/models/my_leaderboard_model.dart';
import 'package:willizo/features/community/data/models/workout_summary_model.dart';
import 'package:willizo/features/community/data/models/sync_contacts_model.dart';
import 'package:willizo/features/community/data/repo/community_repo.dart';

part 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit(this._communityRepo) : super(CommunityInitial());

  final CommunityRepo _communityRepo;

  MyLeaderboardEntry? myEntry;
  List<ExerciseCategoryEntry> exerciseCategories = [];
  List<LeaderboardEntry> leaderboardFriends = [];
  ExerciseInfo? firstCardExercise;
  WorkoutSummaryModel? workoutSummary;

  // Friends list (All Friends tab)
  List<FriendListItem> _friends = [];
  int _friendsCurrentPage = 1;
  int _friendsLastPage = 1;
  String _friendsSearch = '';
  FriendsStats? friendsStats;
  List<FriendListItem> get friends => List.unmodifiable(_friends);
  bool get hasMoreFriends => _friendsCurrentPage < _friendsLastPage;

  // Top followers suggestions (Suggested tab)
  List<TopFollowerSuggestionItem> topFollowers = [];
  bool hasFetchedTopFollowers = false;

  // Near you suggestions (Suggested tab)
  List<NearYouSuggestionItem> nearYouSuggestions = [];
  bool hasFetchedNearYouSuggestions = false;

  /// Fetches suggestions near you (GET /suggestions/near-you).
  Future<void> getSuggestionsNearYou({bool refresh = false}) async {
    if (hasFetchedNearYouSuggestions && !refresh) {
      emit(NearYouSuggestionsLoadedState());
      return;
    }
    emit(NearYouSuggestionsLoadingState());
    final result = await _communityRepo.getSuggestionsNearYou();
    result.fold((failure) => emit(NearYouSuggestionsErrorState(failure)), (
      list,
    ) {
      nearYouSuggestions = list;
      hasFetchedNearYouSuggestions = true;
      emit(NearYouSuggestionsLoadedState());
    });
  }

  // Leagues
  List<LeagueModel> generalLeagues = [];
  List<LeagueModel> invitationalLeagues = [];
  List<LeagueModel> availableLeagues = [];

  // Feeds
  List<FeedModel> feeds = [];
  final Map<String, Timer> _reactionTimers = {};
  final Map<String, FeedModel> _originalFeeds = {};
  final Map<String, Timer> _saveTimers = {};
  final Map<String, FeedModel> _originalSaveFeeds = {};

  // From-your-contacts suggestions (Suggested tab)
  List<ContactSuggestionItem> suggestionsFromContacts = [];
  bool hasFetchedContactsSuggestions = false;

  Future<void> getCommunity() async {
    emit(CommunityLoadingState());
    final result = await _communityRepo.getCommunity();
    result.fold(
      (failure) => emit(CommunityErrorState(failure)),
      (data) => emit(CommunityLoadedState()),
    );
  }

  /// Re-emits leaderboard state if we already have data (e.g. when switching back to Leaderboard tab).
  void restoreLeaderboardState() {
    if (exerciseCategories.isNotEmpty || myEntry != null) {
      emit(
        LeaderboardLoadedState(
          myEntry: myEntry,
          exerciseCategories: exerciseCategories,
          leaderboardFriends: leaderboardFriends,
          firstCardExercise: firstCardExercise,
          workoutSummary: workoutSummary,
        ),
      );
    }
  }

  Future<void> getLeaderboards() async {
    emit(LeaderboardLoadingState());

    final results = await Future.wait([
      _communityRepo.getMyLeaderboard(),
      _communityRepo.getExerciseCategories(),
      _communityRepo.getLeaderboardFriends(),
      _communityRepo.getWorkoutsSummary(),
    ]);

    final myLeaderboardResult = results[0] as dynamic;
    final exerciseResult = results[1] as dynamic;
    final friendsResult = results[2] as dynamic;
    final workoutSummaryResult = results[3] as dynamic;

    // Handle current user's leaderboard result
    Failure? failure;
    myLeaderboardResult.fold(
      (f) {
        failure = f;
      },
      (data) {
        myEntry = data as MyLeaderboardEntry;
      },
    );

    // Handle exercise categories result
    exerciseResult.fold((_) {}, (data) {
      exerciseCategories = data as List<ExerciseCategoryEntry>;
    });

    // Handle leaderboard friends (monthly) result
    friendsResult.fold((_) {}, (data) {
      leaderboardFriends = data as List<LeaderboardEntry>;
    });

    // Handle workout summary (weekly challenge)
    workoutSummaryResult.fold((_) {}, (data) {
      workoutSummary = data as WorkoutSummaryModel?;
    });

    // Fetch first-card exercise name (first category's slug)
    if (exerciseCategories.isNotEmpty) {
      final firstSlug = exerciseCategories.first.exercise.slug;
      final exerciseResult = await _communityRepo.getLeaderboardExercise(
        firstSlug,
      );
      exerciseResult.fold((_) {}, (data) {
        firstCardExercise = data.exercise;
      });
    }

    if (failure != null) {
      emit(LeaderboardErrorState(failure!));
    } else {
      emit(
        LeaderboardLoadedState(
          myEntry: myEntry,
          exerciseCategories: exerciseCategories,
          leaderboardFriends: leaderboardFriends,
          firstCardExercise: firstCardExercise,
          workoutSummary: workoutSummary,
        ),
      );
    }
  }

  /// Fetches friends list for All Friends tab (page 1, or refresh).
  /// If we already have cached friends and [refresh] is false, re-emits cached state without loading.
  Future<void> getFriends({bool refresh = false, String? search}) async {
    final nextSearch = search ?? _friendsSearch;
    final searchChanged = nextSearch != _friendsSearch;
    _friendsSearch = nextSearch;
    if (refresh || searchChanged) {
      _friends = [];
      _friendsCurrentPage = 1;
      _friendsLastPage = 1;
    }
    if (!refresh && !searchChanged && _friends.isNotEmpty) {
      emit(
        FriendsLoadedState(
          friends: _friends,
          currentPage: _friendsCurrentPage,
          lastPage: _friendsLastPage,
          hasMore: hasMoreFriends,
        ),
      );
      return;
    }
    emit(FriendsLoadingState());
    final result = await _communityRepo.getFriends(
      page: 1,
      search: _friendsSearch,
    );
    result.fold((failure) => emit(FriendsErrorState(failure)), (response) {
      _friends = List.from(response.data);
      _friendsCurrentPage = response.currentPage;
      _friendsLastPage = response.lastPage;
      emit(
        FriendsLoadedState(
          friends: _friends,
          currentPage: _friendsCurrentPage,
          lastPage: _friendsLastPage,
          hasMore: response.hasMore,
        ),
      );
    });
  }

  Future<void> getFriendsStats() async {
    emit(FriendsStatsLoadingState());
    final result = await _communityRepo.getFriendsStats();
    result.fold((failure) => emit(FriendsStatsErrorState(failure)), (stats) {
      friendsStats = stats;
      emit(FriendsStatsLoadedState());
    });
  }

  Future<bool> removeFriend(String id) async {
    final result = await _communityRepo.deleteFriend(id);
    return result.fold((_) => false, (_) {
      _friends.removeWhere((item) => item.id == id);
      emit(
        FriendsLoadedState(
          friends: _friends,
          currentPage: _friendsCurrentPage,
          lastPage: _friendsLastPage,
          hasMore: hasMoreFriends,
        ),
      );
      return true;
    });
  }

  /// Loads next page of friends (pagination).
  Future<void> loadMoreFriends() async {
    if (state is FriendsLoadingMoreState) return;
    if (!hasMoreFriends) return;
    final nextPage = _friendsCurrentPage + 1;
    emit(
      FriendsLoadingMoreState(
        friends: _friends,
        currentPage: _friendsCurrentPage,
        lastPage: _friendsLastPage,
        hasMore: hasMoreFriends,
      ),
    );
    final result = await _communityRepo.getFriends(
      page: nextPage,
      search: _friendsSearch,
    );
    result.fold((failure) => emit(FriendsErrorState(failure)), (response) {
      _friends = [..._friends, ...response.data];
      _friendsCurrentPage = response.currentPage;
      _friendsLastPage = response.lastPage;
      emit(
        FriendsLoadedState(
          friends: _friends,
          currentPage: _friendsCurrentPage,
          lastPage: _friendsLastPage,
          hasMore: response.hasMore,
        ),
      );
    });
  }

  /// Fetches top followers suggestions for Suggested tab.
  /// If already cached, re-emits [TopFollowersLoadedState] without calling API.
  Future<void> getTopFollowers({bool refresh = false}) async {
    if (hasFetchedTopFollowers && !refresh) {
      emit(TopFollowersLoadedState());
      return;
    }
    emit(TopFollowersLoadingState());
    final result = await _communityRepo.getTopFollowers();
    result.fold((failure) => emit(TopFollowersErrorState(failure)), (list) {
      topFollowers = list;
      hasFetchedTopFollowers = true;
      emit(TopFollowersLoadedState());
    });
  }

  Future<bool> toggleFollowSuggestedUser({
    required String userId,
    required bool isFollowing,
  }) async {
    final result = isFollowing
        ? await _communityRepo.unfollowUser(userId)
        : await _communityRepo.followUser(userId);
    return result.fold((_) => false, (_) {
      _setFollowing(userId, !isFollowing);
      emit(TopFollowersLoadedState());
      return true;
    });
  }

  void _setFollowing(String userId, bool value) {
    topFollowers = topFollowers
        .map(
          (item) =>
              item.id == userId ? item.copyWith(isFollowing: value) : item,
        )
        .toList();
    nearYouSuggestions = nearYouSuggestions
        .map(
          (item) =>
              item.id == userId ? item.copyWith(isFollowing: value) : item,
        )
        .toList();
    suggestionsFromContacts = suggestionsFromContacts
        .map(
          (item) =>
              item.id == userId ? item.copyWith(isFollowing: value) : item,
        )
        .toList();
  }

  /// Fetches suggestions from contacts (GET /suggestions/from-contacts).
  Future<void> getSuggestionsFromContacts() async {
    emit(ContactsSuggestionsLoadingState());
    final result = await _communityRepo.getSuggestionsFromContacts();
    result.fold((failure) => emit(ContactsSuggestionsErrorState(failure)), (
      list,
    ) {
      suggestionsFromContacts = list;
      hasFetchedContactsSuggestions = true;
      emit(ContactsSuggestionsLoadedState());
    });
  }

  Future<void> syncContacts(SyncContactsRequest request) async {
    emit(ContactsSuggestionsLoadingState());
    final result = await _communityRepo.syncContacts(request);
    result.fold(
      (failure) => emit(ContactsSuggestionsErrorState(failure)),
      (_) => getSuggestionsFromContacts(),
    );
  }

  Future<void> joinLeagueByCode(String code) async {
    emit(LeagueJoiningState());
    final result = await _communityRepo.joinLeagueByCode(code);
    result.fold((failure) => emit(LeagueJoinErrorState(failure)), (_) {
      availableLeagues = [];
      generalLeagues = [];
      invitationalLeagues = [];
      emit(LeagueJoinedState());
    });
  }

  Future<void> joinLeague(String leagueId) async {
    emit(LeagueJoiningState());
    final result = await _communityRepo.joinLeague(leagueId);
    result.fold((failure) => emit(LeagueJoinErrorState(failure)), (_) {
      availableLeagues = [];
      generalLeagues = [];
      invitationalLeagues = [];
      emit(LeagueJoinedState());
    });
  }

  Future<void> createLeague(CreateLeagueRequestModel request) async {
    emit(LeagueCreatingState());
    final result = await _communityRepo.createLeague(request);
    result.fold((failure) => emit(LeagueCreationErrorState(failure)), (
      response,
    ) {
      generalLeagues = [];
      invitationalLeagues = [];
      emit(LeagueCreatedState());
    });
  }

  Future<void> getLeagues({bool refresh = false}) async {
    if (!refresh &&
        (generalLeagues.isNotEmpty || invitationalLeagues.isNotEmpty)) {
      emit(LeaguesLoadedState());
      return;
    }
    emit(LeaguesLoadingState());
    final result = await _communityRepo.getLeagues();
    result.fold((failure) => emit(LeaguesErrorState(failure)), (leagues) {
      generalLeagues = leagues.where((l) => l.type == 'general').toList();
      invitationalLeagues = leagues
          .where((l) => l.type == 'invitational')
          .toList();
      emit(LeaguesLoadedState());
    });
  }

  Future<void> getAvailableLeagues({bool refresh = false}) async {
    if (availableLeagues.isNotEmpty && !refresh) {
      emit(AvailableLeaguesLoadedState());
      return;
    }
    emit(AvailableLeaguesLoadingState());
    final result = await _communityRepo.getAvailableLeagues();
    result.fold((failure) => emit(AvailableLeaguesErrorState(failure)), (
      leagues,
    ) {
      availableLeagues = leagues;
      emit(AvailableLeaguesLoadedState());
    });
  }

  void saveFeed(String feedId) {
    final index = feeds.indexWhere((f) => f.id == feedId);
    if (index == -1) return;

    final feed = feeds[index];

    // Save original state before first tap
    _originalSaveFeeds.putIfAbsent(feedId, () => feed);

    final newSaved = !feed.isSaved;

    feeds[index] = FeedModel(
      id: feed.id,
      user: feed.user,
      content: feed.content,
      mediaType: feed.mediaType,
      mediaUrl: feed.mediaUrl,
      visibility: feed.visibility,
      reactionsCount: feed.reactionsCount,
      reactions: feed.reactions,
      savesCount: newSaved ? feed.savesCount + 1 : feed.savesCount - 1,
      isSaved: newSaved,
      userReaction: feed.userReaction,
      createdAt: feed.createdAt,
      timeAgo: feed.timeAgo,
    );
    emit(FeedsLoadedState());

    // Debounce: only send after 3s of no taps
    _saveTimers[feedId]?.cancel();
    _saveTimers[feedId] = Timer(const Duration(seconds: 3), () {
      _sendSave(feedId);
    });
  }

  Future<void> _sendSave(String feedId) async {
    final index = feeds.indexWhere((f) => f.id == feedId);
    final original = _originalSaveFeeds[feedId];
    if (index == -1 || original == null) return;

    // Only call API if state actually changed from original
    if (feeds[index].isSaved == original.isSaved) {
      _originalSaveFeeds.remove(feedId);
      _saveTimers.remove(feedId);
      return;
    }

    final result = feeds[index].isSaved
        ? await _communityRepo.saveFeed(feedId)
        : await _communityRepo.unsaveFeed(feedId);
    result.fold((failure) {
      feeds[index] = original;
      emit(FeedsLoadedState());
    }, (_) {});
    _originalSaveFeeds.remove(feedId);
    _saveTimers.remove(feedId);
  }

  void reactToFeed(String feedId, String type) {
    final index = feeds.indexWhere((f) => f.id == feedId);
    if (index == -1) return;

    final feed = feeds[index];

    // Save original state before first tap (for revert on error)
    _originalFeeds.putIfAbsent(feedId, () => feed);

    final alreadyReacted = feed.userReaction == type;

    // Toggle: if same reaction, remove it; otherwise set new one
    final newReaction = alreadyReacted ? null : type;
    final newCount = alreadyReacted
        ? feed.reactionsCount - 1
        : (feed.userReaction != null
              ? feed.reactionsCount
              : feed.reactionsCount + 1);

    // Update reactions list (keep per-type counts accurate)
    List<FeedReaction> newReactions = List.from(feed.reactions);
    final existingIndex = newReactions.indexWhere((r) => r.type == type);
    if (alreadyReacted) {
      if (existingIndex != -1) {
        final newTypeCount = newReactions[existingIndex].count - 1;
        if (newTypeCount <= 0) {
          newReactions.removeAt(existingIndex);
        } else {
          newReactions[existingIndex] = FeedReaction(
            type: type,
            count: newTypeCount,
          );
        }
      }
    } else {
      if (existingIndex != -1) {
        newReactions[existingIndex] = FeedReaction(
          type: type,
          count: newReactions[existingIndex].count + 1,
        );
      } else {
        newReactions.add(FeedReaction(type: type, count: 1));
      }
    }

    feeds[index] = FeedModel(
      id: feed.id,
      user: feed.user,
      content: feed.content,
      mediaType: feed.mediaType,
      mediaUrl: feed.mediaUrl,
      visibility: feed.visibility,
      reactionsCount: newCount,
      reactions: newReactions,
      savesCount: feed.savesCount,
      isSaved: feed.isSaved,
      userReaction: newReaction,
      createdAt: feed.createdAt,
      timeAgo: feed.timeAgo,
    );
    emit(FeedsLoadedState());

    // Cancel previous timer and start new 3s debounce
    _reactionTimers[feedId]?.cancel();
    _reactionTimers[feedId] = Timer(const Duration(seconds: 3), () {
      _sendReaction(feedId, type);
    });
  }

  Future<void> _sendReaction(String feedId, String type) async {
    final index = feeds.indexWhere((f) => f.id == feedId);
    final currentReaction = index != -1 ? feeds[index].userReaction : null;

    // If user removed their reaction, use DELETE; otherwise POST
    final result = currentReaction == null
        ? await _communityRepo.removeReaction(feedId)
        : await _communityRepo.reactToFeed(feedId, currentReaction);
    result.fold(
      (failure) {
        // Revert to original on error
        final original = _originalFeeds.remove(feedId);
        if (original != null) {
          final index = feeds.indexWhere((f) => f.id == feedId);
          if (index != -1) {
            feeds[index] = original;
            emit(FeedsLoadedState());
          }
        }
      },
      (_) {
        _originalFeeds.remove(feedId);
      },
    );
    _reactionTimers.remove(feedId);
  }

  Future<void> createPost({
    required String mediaPath,
    String visibility = 'public',
  }) async {
    emit(PostCreatingState());
    final result = await _communityRepo.createPost(
      mediaPath: mediaPath,
      visibility: visibility,
    );
    result.fold((failure) => emit(PostCreationErrorState(failure)), (newFeed) {
      feeds = [newFeed, ...feeds];
      emit(PostCreatedState());
    });
  }

  Future<void> getFeeds({bool refresh = false}) async {
    if (feeds.isNotEmpty && !refresh) {
      emit(FeedsLoadedState());
      return;
    }
    if (feeds.isEmpty) {
      emit(FeedsLoadingState());
    }
    final result = await _communityRepo.getFeeds();
    result.fold((failure) => emit(FeedsErrorState(failure)), (list) {
      feeds = list;
      emit(FeedsLoadedState());
    });
  }

  static CommunityCubit get(context) =>
      BlocProvider.of<CommunityCubit>(context);
}
