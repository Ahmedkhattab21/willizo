class ExerciseCategoryEntry {
  final ExerciseInfo exercise;
  final int participantsCount;
  final int? userRank;
  final int userScore;
  final bool isActive;

  ExerciseCategoryEntry({
    required this.exercise,
    required this.participantsCount,
    this.userRank,
    required this.userScore,
    required this.isActive,
  });

  factory ExerciseCategoryEntry.fromJson(Map<String, dynamic> json) {
    return ExerciseCategoryEntry(
      exercise: ExerciseInfo.fromJson(json['exercise'] ?? {}),
      participantsCount: json['participants_count'] ?? 0,
      userRank: json['user_rank'],
      userScore: json['user_score'] ?? 0,
      isActive: json['is_active'] ?? false,
    );
  }
}

class ExerciseInfo {
  final String id;
  final String name;
  final String slug;
  final String icon;
  final String category;

  ExerciseInfo({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.category,
  });

  factory ExerciseInfo.fromJson(Map<String, dynamic> json) {
    return ExerciseInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      icon: json['icon'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

/// Response from GET /leaderboards/exercise/:slug
class LeaderboardExerciseResponse {
  final ExerciseInfo exercise;
  final List<dynamic> leaderboard;

  LeaderboardExerciseResponse({
    required this.exercise,
    this.leaderboard = const [],
  });

  factory LeaderboardExerciseResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardExerciseResponse(
      exercise: ExerciseInfo.fromJson(json['exercise'] ?? {}),
      leaderboard: json['leaderboard'] as List<dynamic>? ?? [],
    );
  }
}
