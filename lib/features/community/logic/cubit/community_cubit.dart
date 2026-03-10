import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/community/data/models/exercise_category_model.dart';
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
  List<FriendListItem> get friends => List.unmodifiable(_friends);
  bool get hasMoreFriends => _friendsCurrentPage < _friendsLastPage;

  // Top followers suggestions (Suggested tab)
  List<TopFollowerSuggestionItem> topFollowers = [];
  bool hasFetchedTopFollowers = false;

  // Near you suggestions (Suggested tab)
  List<NearYouSuggestionItem> nearYouSuggestions = [];
  bool hasFetchedNearYouSuggestions = false;

  /// Fetches suggestions near you (GET /suggestions/near-you).
  Future<void> getSuggestionsNearYou() async {
    if (hasFetchedNearYouSuggestions) {
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
  Future<void> getFriends({bool refresh = false}) async {
    if (refresh) {
      _friends = [];
      _friendsCurrentPage = 1;
      _friendsLastPage = 1;
    }
    if (!refresh && _friends.isNotEmpty) {
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
    final result = await _communityRepo.getFriends(page: 1);
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
    final result = await _communityRepo.getFriends(page: nextPage);
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
  Future<void> getTopFollowers() async {
    if (hasFetchedTopFollowers) {
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

  Future<void> getLeagues() async {
    if (generalLeagues.isNotEmpty || invitationalLeagues.isNotEmpty) {
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

  static CommunityCubit get(context) =>
      BlocProvider.of<CommunityCubit>(context);
}
