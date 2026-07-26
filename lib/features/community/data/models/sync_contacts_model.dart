/// Request body for POST /suggestions/sync-contacts.
class SyncContactsRequest {
  final List<SyncContactItem> contacts;

  SyncContactsRequest({required this.contacts});

  Map<String, dynamic> toJson() => {
    'contacts': contacts.map((e) => e.toJson()).toList(),
  };
}

class SyncContactItem {
  final String phoneNumber;
  final String name;

  SyncContactItem({required this.phoneNumber, required this.name});

  Map<String, dynamic> toJson() => {'phone_number': phoneNumber, 'name': name};
}

class SyncContactsResponse {
  final String message;

  SyncContactsResponse({required this.message});

  factory SyncContactsResponse.fromJson(Map<String, dynamic> json) =>
      SyncContactsResponse(message: json['message']?.toString() ?? '');
}

/// Item from GET /suggestions/from-contacts (user found from contacts).
class ContactSuggestionItem {
  final String id;
  final String fullName;
  final String? friendId;
  final String phoneNumber;
  final int followersCount;
  final bool isFollowing;

  ContactSuggestionItem({
    required this.id,
    required this.fullName,
    this.friendId,
    required this.phoneNumber,
    required this.followersCount,
    required this.isFollowing,
  });

  factory ContactSuggestionItem.fromJson(Map<String, dynamic> json) {
    return ContactSuggestionItem(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      friendId: json['friend_id']?.toString(),
      phoneNumber: json['phone_number']?.toString() ?? '',
      followersCount: _toInt(json['followers_count']),
      isFollowing: _toBool(json['is_following']),
    );
  }

  ContactSuggestionItem copyWith({bool? isFollowing}) {
    return ContactSuggestionItem(
      id: id,
      fullName: fullName,
      friendId: friendId,
      phoneNumber: phoneNumber,
      followersCount: followersCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value?.toString().toLowerCase().trim() == 'true';
  }
}

/// Item from GET /suggestions/near-you.
class NearYouSuggestionItem {
  final String id;
  final String fullName;
  final String? friendId;
  final int followersCount;
  final double distance;
  final bool isFollowing;

  NearYouSuggestionItem({
    required this.id,
    required this.fullName,
    this.friendId,
    required this.followersCount,
    required this.distance,
    required this.isFollowing,
  });

  factory NearYouSuggestionItem.fromJson(Map<String, dynamic> json) {
    double parsedDistance = 0.0;
    if (json['distance'] != null) {
      if (json['distance'] is String) {
        parsedDistance = double.tryParse(json['distance']) ?? 0.0;
      } else if (json['distance'] is num) {
        parsedDistance = (json['distance'] as num).toDouble();
      }
    }

    return NearYouSuggestionItem(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      friendId: json['friend_id']?.toString(),
      followersCount: _toInt(json['followers_count']),
      distance: parsedDistance,
      isFollowing: _toBool(json['is_following']),
    );
  }

  NearYouSuggestionItem copyWith({bool? isFollowing}) {
    return NearYouSuggestionItem(
      id: id,
      fullName: fullName,
      friendId: friendId,
      followersCount: followersCount,
      distance: distance,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value?.toString().toLowerCase().trim() == 'true';
  }
}

/// Item from GET /suggestions/top-followers.
class TopFollowerSuggestionItem {
  final String id;
  final String fullName;
  final String? friendId;
  final int followersCount;
  final bool isFollowing;

  TopFollowerSuggestionItem({
    required this.id,
    required this.fullName,
    this.friendId,
    required this.followersCount,
    required this.isFollowing,
  });

  factory TopFollowerSuggestionItem.fromJson(Map<String, dynamic> json) {
    return TopFollowerSuggestionItem(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      friendId: json['friend_id']?.toString(),
      followersCount: _toInt(json['followers_count']),
      isFollowing: _toBool(json['is_following']),
    );
  }

  TopFollowerSuggestionItem copyWith({bool? isFollowing}) {
    return TopFollowerSuggestionItem(
      id: id,
      fullName: fullName,
      friendId: friendId,
      followersCount: followersCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value?.toString().toLowerCase().trim() == 'true';
  }
}
