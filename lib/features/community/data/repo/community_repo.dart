import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/community/data/models/community_models.dart';
import 'package:willizo/features/community/data/models/feed_model.dart';
import 'package:willizo/features/community/data/models/exercise_category_model.dart';
import 'package:willizo/features/community/data/models/friend_model.dart';
import 'package:willizo/features/community/data/models/create_league_request_model.dart';
import 'package:willizo/features/community/data/models/create_league_response_model.dart';
import 'package:willizo/features/community/data/models/league_model.dart';
import 'package:willizo/features/community/data/models/leaderboard_model.dart';
import 'package:willizo/features/community/data/models/my_leaderboard_model.dart';
import 'package:willizo/features/community/data/models/workout_summary_model.dart';
import 'package:willizo/features/community/data/models/sync_contacts_model.dart';
import 'package:willizo/features/community/data/services/community_services.dart';

class CommunityRepo {
  final CommunityServices communityServices;

  CommunityRepo({required this.communityServices});

  Future<Either<Failure, CommunityResponseModel>> getCommunity() async {
    try {
      final response = await communityServices.getCommunity();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, void>> joinLeagueByCode(String code) async {
    try {
      await communityServices.joinLeagueByCode(code);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, void>> joinLeague(String leagueId) async {
    try {
      await communityServices.joinLeague(leagueId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboards() async {
    try {
      final response = await communityServices.getLeaderboards();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, MyLeaderboardEntry>> getMyLeaderboard() async {
    try {
      final response = await communityServices.getMyLeaderboard();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, List<ExerciseCategoryEntry>>>
  getExerciseCategories() async {
    try {
      final response = await communityServices.getExerciseCategories();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, List<LeaderboardEntry>>>
  getLeaderboardFriends() async {
    try {
      final response = await communityServices.getLeaderboardFriends();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, LeaderboardExerciseResponse>> getLeaderboardExercise(
    String slug,
  ) async {
    try {
      final response = await communityServices.getLeaderboardExercise(slug);
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, WorkoutSummaryModel?>> getWorkoutsSummary() async {
    try {
      final response = await communityServices.getWorkoutsSummary();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, SyncContactsResponse>> syncContacts(
    SyncContactsRequest request,
  ) async {
    try {
      final response = await communityServices.syncContacts(request);
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, List<ContactSuggestionItem>>>
  getSuggestionsFromContacts() async {
    try {
      final response = await communityServices.getSuggestionsFromContacts();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, List<TopFollowerSuggestionItem>>>
  getTopFollowers() async {
    try {
      final response = await communityServices.getTopFollowers();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, List<NearYouSuggestionItem>>>
  getSuggestionsNearYou() async {
    try {
      final response = await communityServices.getSuggestionsNearYou();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, FriendsListResponse>> getFriends({
    int page = 1,
    String? search,
  }) async {
    try {
      final response = await communityServices.getFriends(
        page: page,
        search: search,
      );
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, FriendsStats>> getFriendsStats() async {
    try {
      final response = await communityServices.getFriendsStats();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, AddFriendResponse>> addFriend(String friendId) async {
    try {
      final response = await communityServices.addFriend(friendId);
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, void>> followUser(String userId) async {
    try {
      await communityServices.followUser(userId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, void>> unfollowUser(String userId) async {
    try {
      await communityServices.unfollowUser(userId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, void>> deleteFriend(String id) async {
    try {
      await communityServices.deleteFriend(id);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, String>> generateInviteLink() async {
    try {
      final response = await communityServices.generateInviteLink();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, CreateLeagueResponseModel>> createLeague(
    CreateLeagueRequestModel request,
  ) async {
    try {
      final response = await communityServices.createLeague(request);
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, List<LeagueModel>>> getLeagues() async {
    try {
      final response = await communityServices.getLeagues();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, List<LeagueModel>>> getAvailableLeagues() async {
    try {
      final response = await communityServices.getAvailableLeagues();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, void>> saveFeed(String feedId) async {
    try {
      await communityServices.saveFeed(feedId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, void>> unsaveFeed(String feedId) async {
    try {
      await communityServices.unsaveFeed(feedId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, void>> removeReaction(String feedId) async {
    try {
      await communityServices.removeReaction(feedId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, void>> reactToFeed(String feedId, String type) async {
    try {
      await communityServices.reactToFeed(feedId, type);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, FeedModel>> createPost({
    required String mediaPath,
    String visibility = 'public',
  }) async {
    try {
      final response = await communityServices.createPost(
        mediaPath: mediaPath,
        visibility: visibility,
      );
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, List<FeedModel>>> getFeeds() async {
    try {
      final response = await communityServices.getFeeds();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }
}
