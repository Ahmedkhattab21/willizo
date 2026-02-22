import 'package:bloc/bloc.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/community/data/models/exercise_category_model.dart';
import 'package:willizo/features/community/data/models/friend_model.dart';
import 'package:willizo/features/community/data/models/leaderboard_model.dart';
import 'package:willizo/features/community/data/models/my_leaderboard_model.dart';
import 'package:willizo/features/community/data/repo/community_repo.dart';

part 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit(this._communityRepo) : super(CommunityInitial());

  final CommunityRepo _communityRepo;

  MyLeaderboardEntry? myEntry;
  List<ExerciseCategoryEntry> exerciseCategories = [];
  List<LeaderboardEntry> leaderboardFriends = [];
  ExerciseInfo? firstCardExercise;

  // Friends list (All Friends tab)
  List<FriendListItem> _friends = [];
  int _friendsCurrentPage = 1;
  int _friendsLastPage = 1;
  List<FriendListItem> get friends => List.unmodifiable(_friends);
  bool get hasMoreFriends => _friendsCurrentPage < _friendsLastPage;

  Future<void> getCommunity() async {
    emit(CommunityLoadingState());
    final result = await _communityRepo.getCommunity();
    result.fold(
      (failure) => emit(CommunityErrorState(failure)),
      (data) => emit(CommunityLoadedState()),
    );
  }

  Future<void> getLeaderboards() async {
    emit(LeaderboardLoadingState());

    // Fetch current user's leaderboard, exercise categories, and friends in parallel
    final results = await Future.wait([
      _communityRepo.getMyLeaderboard(),
      _communityRepo.getExerciseCategories(),
      _communityRepo.getLeaderboardFriends(),
    ]);

    final myLeaderboardResult = results[0] as dynamic;
    final exerciseResult = results[1] as dynamic;
    final friendsResult = results[2] as dynamic;

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
    exerciseResult.fold(
      (_) {},
      (data) {
        exerciseCategories = data as List<ExerciseCategoryEntry>;
      },
    );

    // Handle leaderboard friends (monthly) result
    friendsResult.fold(
      (_) {},
      (data) {
        leaderboardFriends = data as List<LeaderboardEntry>;
      },
    );

    // Fetch first-card exercise name (first category's slug)
    if (exerciseCategories.isNotEmpty) {
      final firstSlug = exerciseCategories.first.exercise.slug;
      final exerciseResult = await _communityRepo.getLeaderboardExercise(firstSlug);
      exerciseResult.fold(
        (_) {},
        (data) {
          firstCardExercise = data.exercise;
        },
      );
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
        ),
      );
    }
  }

  /// Fetches friends list for All Friends tab (page 1, or refresh).
  Future<void> getFriends({bool refresh = false}) async {
    if (refresh) {
      _friends = [];
      _friendsCurrentPage = 1;
      _friendsLastPage = 1;
    }
    emit(FriendsLoadingState());
    final result = await _communityRepo.getFriends(page: 1);
    result.fold(
      (failure) => emit(FriendsErrorState(failure)),
      (response) {
        _friends = List.from(response.data);
        _friendsCurrentPage = response.currentPage;
        _friendsLastPage = response.lastPage;
        emit(FriendsLoadedState(
          friends: _friends,
          currentPage: _friendsCurrentPage,
          lastPage: _friendsLastPage,
          hasMore: response.hasMore,
        ));
      },
    );
  }

  /// Loads next page of friends (pagination).
  Future<void> loadMoreFriends() async {
    if (state is FriendsLoadingMoreState) return;
    if (!hasMoreFriends) return;
    final nextPage = _friendsCurrentPage + 1;
    emit(FriendsLoadingMoreState(
      friends: _friends,
      currentPage: _friendsCurrentPage,
      lastPage: _friendsLastPage,
      hasMore: hasMoreFriends,
    ));
    final result = await _communityRepo.getFriends(page: nextPage);
    result.fold(
      (failure) => emit(FriendsErrorState(failure)),
      (response) {
        _friends = [..._friends, ...response.data];
        _friendsCurrentPage = response.currentPage;
        _friendsLastPage = response.lastPage;
        emit(FriendsLoadedState(
          friends: _friends,
          currentPage: _friendsCurrentPage,
          lastPage: _friendsLastPage,
          hasMore: response.hasMore,
        ));
      },
    );
  }
}
