import 'package:willizo/core/api/end_points.dart';

class CommunityApiEndpoint {
  static const String communityUrl = '${EndPoints.baseUrl}api/community';
  static const String leaderboardsUrl = '${EndPoints.baseUrl}/leaderboards';
  static const String leaderboardsMeUrl =
      '${EndPoints.baseUrl}/leaderboards/me';
  static const String exerciseCategoriesUrl =
      '${EndPoints.baseUrl}/leaderboards/exercise-categories';
  static const String leaderboardsFriendsUrl =
      '${EndPoints.baseUrl}/leaderboards/friends?period=monthly';

  static const String friendsUrl = '${EndPoints.baseUrl}/friends';
  static const String friendRequestsUrl =
      '${EndPoints.baseUrl}/friends/requests';
  static const String friendsStatsUrl = '${EndPoints.baseUrl}/friends/stats';
  static String friendsUrlWithPage(int page, {String? search, String? status}) {
    final params = <String, String>{'page': page.toString()};
    if (search != null && search.trim().isNotEmpty) {
      params['search'] = search.trim();
    }
    if (status != null && status.trim().isNotEmpty) {
      params['status'] = status.trim();
    }
    return Uri.parse(friendsUrl).replace(queryParameters: params).toString();
  }

  static const String addFriendUrl = '${EndPoints.baseUrl}/friends/add';

  static String followUserUrl(String userId) =>
      '${EndPoints.baseUrl}/follow/$userId';

  static String deleteFriendUrl(String id) =>
      '${EndPoints.baseUrl}/friends/$id';

  static String acceptFriendRequestUrl(String id) =>
      '${EndPoints.baseUrl}/friends/accept/$id';

  static String rejectFriendRequestUrl(String id) =>
      '${EndPoints.baseUrl}/friends/reject/$id';

  static const String generateInviteLinkUrl =
      '${EndPoints.baseUrl}/friends/invite';

  static String leaderboardExerciseUrl(String slug) =>
      '${EndPoints.baseUrl}/leaderboards/exercise/$slug';

  static const String workoutsSummaryUrl =
      '${EndPoints.baseUrl}/workouts/summary';

  /// Sync device contacts for friend suggestions. POST with body {"contacts": [{ "phone_number", "name" }, ...]}.
  static const String syncContactsUrl =
      '${EndPoints.baseUrl}/suggestions/sync-contacts';

  /// Fetch suggestions from contacts (users found in your contacts). GET /suggestions/from-contacts.
  static const String suggestionsFromContactsUrl =
      '${EndPoints.baseUrl}/suggestions/from-contacts';

  /// Fetch suggestions near you. GET /suggestions/near-you.
  static const String suggestionsNearYouUrl =
      '${EndPoints.baseUrl}/suggestions/near-you';

  /// Fetch top followers suggestions. GET /suggestions/top-followers.
  static const String suggestionsTopFollowersUrl =
      '${EndPoints.baseUrl}/suggestions/top-followers';

  /// Fetch all leagues (general + invitational). GET /leagues.
  static const String leaguesUrl = '${EndPoints.baseUrl}/leagues';

  /// Fetch available leagues the user can join. GET /leagues/available.
  static const String availableLeaguesUrl =
      '${EndPoints.baseUrl}/leagues/available';

  /// Join a league by ID. POST /leagues/join.
  static const String joinLeagueUrl = '${EndPoints.baseUrl}/leagues/join';

  /// Fetch feeds. GET /feeds.
  static const String feedsUrl = '${EndPoints.baseUrl}/feeds';

  /// React to a feed post. POST /feeds/:id/react.
  static String feedReactUrl(String id) =>
      '${EndPoints.baseUrl}/feeds/$id/react';

  /// Save a feed post. POST /feeds/:id/save.
  static String feedSaveUrl(String id) => '${EndPoints.baseUrl}/feeds/$id/save';

  /// Create a new feed post. POST /feeds (multipart form-data).
  static const String createFeedUrl = '${EndPoints.baseUrl}/feeds';
}
