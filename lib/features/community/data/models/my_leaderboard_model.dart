class MyLeaderboardEntry {
  final String id;
  final String userId;
  final String? exerciseId;
  final String period;
  final int score;
  final int rank;
  final int previousRank;
  final String periodStart;
  final String periodEnd;

  MyLeaderboardEntry({
    required this.id,
    required this.userId,
    this.exerciseId,
    required this.period,
    required this.score,
    required this.rank,
    required this.previousRank,
    required this.periodStart,
    required this.periodEnd,
  });

  factory MyLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return MyLeaderboardEntry(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      exerciseId: json['exercise_id'],
      period: json['period'] ?? '',
      score: json['score'] ?? 0,
      rank: json['rank'] ?? 0,
      previousRank: json['previous_rank'] ?? 0,
      periodStart: json['period_start'] ?? '',
      periodEnd: json['period_end'] ?? '',
    );
  }
}
