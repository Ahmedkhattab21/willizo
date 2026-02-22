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

  /// Friends list (All Friends tab) with pagination.
  static const String friendsUrl = '${EndPoints.baseUrl}/friends';
  static String friendsUrlWithPage(int page) =>
      '${EndPoints.baseUrl}/friends?page=$page';

  /// Remove friend by friendship record id.
  static String deleteFriendUrl(String id) => '${EndPoints.baseUrl}/friends/$id';

  /// Generate a friend invite link.
  static const String generateInviteLinkUrl = '${EndPoints.baseUrl}/friends/invite';

  static String leaderboardExerciseUrl(String slug) =>
      '${EndPoints.baseUrl}/leaderboards/exercise/$slug';
}
