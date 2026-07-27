import 'package:willizo/core/api/end_points.dart';

/// Nested friend user data from API (inside each list item).
class Friend {
  final String id;
  final String fullName;
  final String email;
  final String? friendId;
  final String? profilePhoto;
  final String? lastActiveAt;
  final String? currentActivity;
  final bool isOnline;

  Friend({
    required this.id,
    required this.fullName,
    required this.email,
    this.friendId,
    this.profilePhoto,
    this.lastActiveAt,
    this.currentActivity,
    this.isOnline = false,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    final rawPhoto = json['profile_photo']?.toString();
    return Friend(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      friendId: json['friend_id']?.toString(),
      profilePhoto: _imageUrl(rawPhoto),
      lastActiveAt: json['last_active_at']?.toString(),
      currentActivity: json['current_activity']?.toString(),
      isOnline: json['is_online'] == true,
    );
  }

  bool get isActiveNow =>
      currentActivity != null && currentActivity!.isNotEmpty;

  static String? _imageUrl(String? value) {
    final rawValue = value?.trim() ?? '';
    if (rawValue.isEmpty || rawValue == '/storage/') return null;
    if (rawValue.startsWith('http')) return rawValue;
    if (rawValue.startsWith('/storage/')) {
      return '${Uri.parse(EndPoints.baseUrl).origin}$rawValue';
    }
    return EndPoints.getImageFromApi(rawValue);
  }
}

/// Single item in the friends list (relationship + nested friend).
class FriendListItem {
  final String id;
  final String userId;
  final String friendId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Friend friend;

  FriendListItem({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.friend,
  });

  factory FriendListItem.fromJson(Map<String, dynamic> json) {
    final friendJson =
        json['friend'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>? ??
        {};
    return FriendListItem(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      friendId: json['friend_id']?.toString() ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      friend: Friend.fromJson(friendJson),
    );
  }
}

class FriendsStats {
  final int friendsCount;
  final int workoutPartnersCount;
  final int activeTodayCount;

  const FriendsStats({
    required this.friendsCount,
    required this.workoutPartnersCount,
    required this.activeTodayCount,
  });

  factory FriendsStats.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return FriendsStats(
      friendsCount: _toInt(data['friends_count']),
      workoutPartnersCount: _toInt(data['workout_partners_count']),
      activeTodayCount: _toInt(data['active_today_count']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

/// Response from POST /friends/add (add friend by friend_id).
class AddFriendResponse {
  final String message;
  final FriendListItem friendship;

  AddFriendResponse({required this.message, required this.friendship});

  factory AddFriendResponse.fromJson(Map<String, dynamic> json) {
    return AddFriendResponse(
      message: json['message'] ?? '',
      friendship: FriendListItem.fromJson(
        json['friendship'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

/// Paginated response for GET /friends.
class FriendsListResponse {
  final int currentPage;
  final List<FriendListItem> data;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  FriendsListResponse({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  factory FriendsListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] ?? [];
    return FriendsListResponse(
      currentPage: json['current_page'] ?? 1,
      data: dataList
          .map((e) => FriendListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url']?.toString(),
      from: json['from'],
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url']?.toString(),
      nextPageUrl: json['next_page_url']?.toString(),
      path: json['path']?.toString(),
      perPage: json['per_page'] ?? 20,
      prevPageUrl: json['prev_page_url']?.toString(),
      to: json['to'],
      total: json['total'] ?? 0,
    );
  }
}
