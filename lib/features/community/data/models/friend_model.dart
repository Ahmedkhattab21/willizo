/// Nested friend user data from API (inside each list item).
class Friend {
  final String id;
  final String fullName;
  final String email;
  final String? friendId;
  final String? lastActiveAt;
  final String? currentActivity;

  Friend({
    required this.id,
    required this.fullName,
    required this.email,
    this.friendId,
    this.lastActiveAt,
    this.currentActivity,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      friendId: json['friend_id']?.toString(),
      lastActiveAt: json['last_active_at']?.toString(),
      currentActivity: json['current_activity']?.toString(),
    );
  }

  bool get isActiveNow =>
      currentActivity != null && currentActivity!.isNotEmpty;
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
    return FriendListItem(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      friendId: json['friend_id']?.toString() ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      friend: Friend.fromJson(json['friend'] as Map<String, dynamic>? ?? {}),
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
