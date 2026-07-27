import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
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
  Future<FriendsListResponse> getFriends({
    int page = 1,
    String? search,
    String? status,
  }) async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.friendsUrlWithPage(
        page,
        search: search,
        status: status,
      ),
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

  Future<List<FriendListItem>> getFriendRequests() async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.friendRequestsUrl,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final decodedBody = jsonDecode(response.body);
      final requestsJson = _extractListFromResponse(decodedBody);
      return requestsJson
          .whereType<Map<String, dynamic>>()
          .map(FriendListItem.fromJson)
          .toList();
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  List<dynamic> _extractListFromResponse(dynamic decodedBody) {
    if (decodedBody is List) return decodedBody;
    if (decodedBody is! Map<String, dynamic>) return const [];

    final data = decodedBody['data'];
    if (data is List) return data;
    if (data is Map<String, dynamic> && data['data'] is List) {
      return data['data'] as List;
    }
    if (decodedBody['requests'] is List) return decodedBody['requests'] as List;

    return const [];
  }

  Future<FriendsStats> getFriendsStats() async {
    final response = await apiConsumer.get(CommunityApiEndpoint.friendsStatsUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return FriendsStats.fromJson(jsonDecode(response.body));
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

  Future<void> followUser(String userId) async {
    final response = await apiConsumer.post(
      CommunityApiEndpoint.followUserUrl(userId),
      {},
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

  Future<void> unfollowUser(String userId) async {
    final response = await apiConsumer.delete(
      CommunityApiEndpoint.followUserUrl(userId),
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

  Future<void> acceptFriendRequest(String id) async {
    await _postFriendRequestAction(
      CommunityApiEndpoint.acceptFriendRequestUrl(id),
    );
  }

  Future<void> rejectFriendRequest(String id) async {
    await _postFriendRequestAction(
      CommunityApiEndpoint.rejectFriendRequestUrl(id),
    );
  }

  Future<void> _postFriendRequestAction(String url) async {
    final response = await apiConsumer.post(url, {}, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

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
  Future<LeaderboardExerciseResponse> getLeaderboardExercise(
    String slug,
  ) async {
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

  /// Syncs device contacts for friend suggestions. POST /suggestions/sync-contacts.
  Future<SyncContactsResponse> syncContacts(SyncContactsRequest request) async {
    final response = await apiConsumer.post(
      CommunityApiEndpoint.syncContactsUrl,
      request.toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return SyncContactsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Fetches suggestions from contacts (users found in your contacts). GET /suggestions/from-contacts.
  Future<List<ContactSuggestionItem>> getSuggestionsFromContacts() async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.suggestionsFromContactsUrl,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final body = jsonDecode(response.body);
      if (body is! List) return [];
      return body
          .map((e) => ContactSuggestionItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Fetches top followers suggestions. GET /suggestions/top-followers.
  Future<List<TopFollowerSuggestionItem>> getTopFollowers() async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.suggestionsTopFollowersUrl,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final body = jsonDecode(response.body);
      if (body is! List) return [];
      return body
          .map(
            (e) =>
                TopFollowerSuggestionItem.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Creates a new league. POST /leagues.
  Future<CreateLeagueResponseModel> createLeague(
    CreateLeagueRequestModel request,
  ) async {
    final response = await apiConsumer.post(
      CommunityApiEndpoint.leaguesUrl,
      request.toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return CreateLeagueResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Fetches available leagues the user can join. GET /leagues/available.
  Future<List<LeagueModel>> getAvailableLeagues() async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.availableLeaguesUrl,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> data = body['data'] as List<dynamic>;
      return data
          .map((item) => LeagueModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Joins an invitational league by code. POST /leagues/join.
  Future<void> joinLeagueByCode(String code) async {
    final response = await apiConsumer.post(
      CommunityApiEndpoint.joinLeagueUrl,
      {'code': code},
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return;
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Joins a league by ID. POST /leagues/join.
  Future<void> joinLeague(String leagueId) async {
    final response = await apiConsumer.post(
      CommunityApiEndpoint.joinLeagueUrl,
      {'league_id': leagueId},
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return;
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Fetches all leagues. GET /leagues.
  Future<List<LeagueModel>> getLeagues() async {
    final response = await apiConsumer.get(CommunityApiEndpoint.leaguesUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((item) => LeagueModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Fetches feeds. GET /feeds.
  Future<List<FeedModel>> getFeeds() async {
    final response = await apiConsumer.get(CommunityApiEndpoint.feedsUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> data = body['data'] as List<dynamic>;
      return data
          .map((item) => FeedModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Saves a feed post. POST /feeds/:id/save.
  Future<void> saveFeed(String feedId) async {
    final response = await apiConsumer.post(
      CommunityApiEndpoint.feedSaveUrl(feedId),
      null,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return;
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Unsaves a feed post. DELETE /feeds/:id/save.
  Future<void> unsaveFeed(String feedId) async {
    final response = await apiConsumer.delete(
      CommunityApiEndpoint.feedSaveUrl(feedId),
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

  /// Removes a reaction from a feed post. DELETE /feeds/:id/react.
  Future<void> removeReaction(String feedId) async {
    final response = await apiConsumer.delete(
      CommunityApiEndpoint.feedReactUrl(feedId),
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

  /// Reacts to a feed post. POST /feeds/:id/react.
  Future<void> reactToFeed(String feedId, String type) async {
    final response = await apiConsumer.post(
      CommunityApiEndpoint.feedReactUrl(feedId),
      {'type': type},
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return;
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Creates a new feed post. POST /feeds (multipart form-data).
  /// [mediaPath] is the local file path, [visibility] defaults to "public".
  Future<FeedModel> createPost({
    required String mediaPath,
    String visibility = 'public',
  }) async {
    final response = await apiConsumer.multiPost(
      CommunityApiEndpoint.createFeedUrl,
      {'media': mediaPath, 'visibility': visibility},
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      return FeedModel.fromJson(data);
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  /// Fetches suggestions near you. GET /suggestions/near-you.
  Future<List<NearYouSuggestionItem>> getSuggestionsNearYou() async {
    final response = await apiConsumer.get(
      CommunityApiEndpoint.suggestionsNearYouUrl,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final body = jsonDecode(response.body);
      if (body is! List) return [];
      return body
          .map((e) => NearYouSuggestionItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
