import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/community/data/models/community_models.dart';
import 'package:willizo/features/community/data/models/exercise_category_model.dart';
import 'package:willizo/features/community/data/models/friend_model.dart';
import 'package:willizo/features/community/data/models/leaderboard_model.dart';
import 'package:willizo/features/community/data/models/my_leaderboard_model.dart';
import 'package:willizo/features/community/data/models/workout_summary_model.dart';
import 'package:willizo/features/community/data/services/community_api_endpoint.dart';

class CommunityServices {
  final ApiConsumer apiConsumer;
  CommunityServices(this.apiConsumer);

  Future<CommunityResponseModel> getCommunity() async {
    final response = await apiConsumer.get(CommunityApiEndpoint.communityUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return CommunityResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<List<LeaderboardEntry>> getLeaderboards() async {
    final response = await apiConsumer.get(CommunityApiEndpoint.leaderboardsUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => LeaderboardEntry.fromJson(item)).toList();
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<MyLeaderboardEntry> getMyLeaderboard() async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.leaderboardsMeUrl,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return MyLeaderboardEntry.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<List<ExerciseCategoryEntry>> getExerciseCategories() async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.exerciseCategoriesUrl,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((item) => ExerciseCategoryEntry.fromJson(item))
          .toList();
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Fetches leaderboard friends (period is monthly, see [CommunityApiEndpoint.leaderboardsFriendsUrl]).
  Future<List<LeaderboardEntry>> getLeaderboardFriends() async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.leaderboardsFriendsUrl,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => LeaderboardEntry.fromJson(item)).toList();
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Fetches friends list (All Friends tab) with pagination.
  Future<FriendsListResponse> getFriends({int page = 1}) async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.friendsUrlWithPage(page),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return FriendsListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Adds a friend by friend_id (e.g. LUZWGQTB). POST /friends/add.
  Future<AddFriendResponse> addFriend(String friendId) async {
    final response = await apiConsumer.post(
      CommunityApiEndpoint.addFriendUrl,
      {'friend_id': friendId},
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return AddFriendResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Removes a friend (DELETE /friends/:id). [id] is the friendship record id.
  Future<void> deleteFriend(String id) async {
    final response = await apiConsumer.delete(
      CommunityApiEndpoint.deleteFriendUrl(id),
      null,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created ||
        response.statusCode == StatusCode.noContent) {
      return;
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Generates a friend invite link.
  Future<String> generateInviteLink() async {
    final response = await apiConsumer.post(
      CommunityApiEndpoint.generateInviteLinkUrl,
      null,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final json = jsonDecode(response.body);
      return json['url'] as String;
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Fetches exercise details and leaderboard by slug (e.g. "push-ups").
  Future<LeaderboardExerciseResponse> getLeaderboardExercise(String slug) async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.leaderboardExerciseUrl(slug),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return LeaderboardExerciseResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Fetches workout summary for weekly challenge (GET /workouts/summary).
  Future<WorkoutSummaryModel?> getWorkoutsSummary() async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.workoutsSummaryUrl,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final body = jsonDecode(response.body);
      if (body == null) return null;
      if (body is List) {
        final list = body;
        if (list.isEmpty) return null;
        return WorkoutSummaryModel.fromJson(list.first as Map<String, dynamic>);
      }
      return WorkoutSummaryModel.fromJson(body as Map<String, dynamic>);
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
