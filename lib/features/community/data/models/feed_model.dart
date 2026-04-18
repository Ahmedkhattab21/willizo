import 'package:willizo/core/api/end_points.dart';

class FeedReaction {
  final String type;
  final int count;

  FeedReaction({required this.type, this.count = 0});
}

class FeedUser {
  final String id;
  final String fullName;
  final String friendId;
  final String? profilePhoto;

  FeedUser({
    required this.id,
    required this.fullName,
    required this.friendId,
    this.profilePhoto,
  });

  factory FeedUser.fromJson(Map<String, dynamic> json) {
    final rawPhoto = json['profile_photo']?.toString();
    return FeedUser(
      id: (json['id'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
      friendId: (json['friend_id'] ?? '').toString(),
      profilePhoto: (rawPhoto != null && rawPhoto.isNotEmpty)
          ? EndPoints.getImageFromApi(rawPhoto)
          : null,
    );
  }
}

class FeedModel {
  final String id;
  final FeedUser user;
  final String content;
  final String? mediaType;
  final String? mediaUrl;
  final String visibility;
  final int reactionsCount;
  final List<FeedReaction> reactions;
  final int savesCount;
  final bool isSaved;
  final String? userReaction;
  final String createdAt;
  final String timeAgo;

  FeedModel({
    required this.id,
    required this.user,
    required this.content,
    this.mediaType,
    this.mediaUrl,
    required this.visibility,
    required this.reactionsCount,
    required this.reactions,
    required this.savesCount,
    required this.isSaved,
    this.userReaction,
    required this.createdAt,
    required this.timeAgo,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    // Build reactions list from reactions_summary object (only types with count > 0)
    final summary = json['reactions_summary'];
    final List<FeedReaction> reactions = [];
    if (summary is Map<String, dynamic>) {
      for (final entry in summary.entries) {
        final count = (entry.value as num?)?.toInt() ?? 0;
        if (count > 0) {
          reactions.add(FeedReaction(type: entry.key, count: count));
        }
      }
    }

    final rawMediaUrl = json['media_url']?.toString();
    // media_url is a relative path like "/storage/posts/xxx.jpg"
    // Base domain is extracted from EndPoints.baseUrl (e.g. "https://willizo.com")
    final imageDomain = Uri.parse(EndPoints.baseUrl).origin;
    final fullMediaUrl = (rawMediaUrl != null && rawMediaUrl.isNotEmpty)
        ? '$imageDomain$rawMediaUrl'
        : null;

    return FeedModel(
      id: (json['id'] ?? '').toString(),
      user: json['user'] is Map<String, dynamic>
          ? FeedUser.fromJson(json['user'] as Map<String, dynamic>)
          : FeedUser(id: '', fullName: '', friendId: ''),
      content: (json['content'] ?? '').toString(),
      mediaType: json['media_type']?.toString(),
      mediaUrl: fullMediaUrl,
      visibility: (json['visibility'] ?? 'public').toString(),
      reactionsCount: (json['reactions_count'] as num?)?.toInt() ?? 0,
      reactions: reactions,
      savesCount: (json['saves_count'] as num?)?.toInt() ?? 0,
      isSaved: json['is_saved'] == true,
      userReaction: json['user_reaction']?.toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      timeAgo: (json['time_ago'] ?? '').toString(),
    );
  }
}
