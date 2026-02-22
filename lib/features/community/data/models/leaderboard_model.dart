class LeaderboardEntry {
  final String id;
  final String userId;
  final String? exerciseId;
  final String period;
  final int score;
  final int rank;
  final int previousRank;
  final String periodStart;
  final String periodEnd;
  final LeaderboardUser user;

  LeaderboardEntry({
    required this.id,
    required this.userId,
    this.exerciseId,
    required this.period,
    required this.score,
    required this.rank,
    required this.previousRank,
    required this.periodStart,
    required this.periodEnd,
    required this.user,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      exerciseId: json['exercise_id'],
      period: json['period'] ?? '',
      score: json['score'] ?? 0,
      rank: json['rank'] ?? 0,
      previousRank: json['previous_rank'] ?? 0,
      periodStart: json['period_start'] ?? '',
      periodEnd: json['period_end'] ?? '',
      user: LeaderboardUser.fromJson(json['user'] ?? {}),
    );
  }
}

class LeaderboardUser {
  final String id;
  final String fullName;
  final String? friendId;

  LeaderboardUser({
    required this.id,
    required this.fullName,
    this.friendId,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      friendId: json['friend_id'],
    );
  }
}
