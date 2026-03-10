class LeagueModel {
  final String id;
  final String name;
  final String? code;
  final String type; // "general" or "invitational"
  final String scoringType;
  final String description;
  final bool isActive;
  final int membersCount;
  final LeagueCreator creator;
  final List<LeagueMember> members;

  LeagueModel({
    required this.id,
    required this.name,
    this.code,
    required this.type,
    required this.scoringType,
    required this.description,
    required this.isActive,
    required this.membersCount,
    required this.creator,
    required this.members,
  });

  factory LeagueModel.fromJson(Map<String, dynamic> json) => LeagueModel(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String?,
    type: json['type'] as String,
    scoringType: json['scoring_type'] as String,
    description: json['description'] as String? ?? '',
    isActive: json['is_active'] as bool? ?? true,
    membersCount: json['members_count'] as int? ?? 0,
    creator: LeagueCreator.fromJson(json['creator'] as Map<String, dynamic>),
    members: (json['members'] as List<dynamic>? ?? [])
        .map((m) => LeagueMember.fromJson(m as Map<String, dynamic>))
        .toList(),
  );
}

class LeagueCreator {
  final String id;
  final String fullName;
  final String friendId;

  LeagueCreator({
    required this.id,
    required this.fullName,
    required this.friendId,
  });

  factory LeagueCreator.fromJson(Map<String, dynamic> json) => LeagueCreator(
    id: json['id'] as String,
    fullName: json['full_name'] as String,
    friendId: json['friend_id'] as String,
  );
}

class LeagueMember {
  final String id;
  final String leagueId;
  final String userId;
  final int totalPoints;
  final int rank;
  final int? previousRank;

  LeagueMember({
    required this.id,
    required this.leagueId,
    required this.userId,
    required this.totalPoints,
    required this.rank,
    this.previousRank,
  });

  factory LeagueMember.fromJson(Map<String, dynamic> json) => LeagueMember(
    id: json['id'] as String,
    leagueId: json['league_id'] as String,
    userId: json['user_id'] as String,
    totalPoints: json['total_points'] as int? ?? 0,
    rank: json['rank'] as int? ?? 0,
    previousRank: json['previous_rank'] as int?,
  );
}
