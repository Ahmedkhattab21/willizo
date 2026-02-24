import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/community/data/models/community_models.dart';
import 'package:willizo/features/community/data/models/exercise_category_model.dart';
import 'package:willizo/features/community/data/models/friend_model.dart';
import 'package:willizo/features/community/data/models/leaderboard_model.dart';
import 'package:willizo/features/community/data/models/my_leaderboard_model.dart';
import 'package:willizo/features/community/data/models/workout_summary_model.dart';
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

  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboardFriends() async {
    try {
      final response = await communityServices.getLeaderboardFriends();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, LeaderboardExerciseResponse>> getLeaderboardExercise(
      String slug) async {
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

  Future<Either<Failure, FriendsListResponse>> getFriends({int page = 1}) async {
    try {
      final response = await communityServices.getFriends(page: page);
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
}
