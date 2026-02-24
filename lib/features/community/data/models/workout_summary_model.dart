/// Response from GET /workouts/summary (single exercise summary).
class WorkoutSummaryModel {
  final String exerciseId;
  final int totalValue;
  final int workoutCount;
  final WorkoutSummaryExercise exercise;

  WorkoutSummaryModel({
    required this.exerciseId,
    required this.totalValue,
    required this.workoutCount,
    required this.exercise,
  });

  factory WorkoutSummaryModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSummaryModel(
      exerciseId: json['exercise_id'] ?? '',
      totalValue: json['total_value'] ?? 0,
      workoutCount: json['workout_count'] ?? 0,
      exercise: WorkoutSummaryExercise.fromJson(
        json['exercise'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class WorkoutSummaryExercise {
  final String id;
  final String name;
  final String slug;
  final String icon;
  final String unit;

  WorkoutSummaryExercise({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.unit,
  });

  factory WorkoutSummaryExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutSummaryExercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      icon: json['icon'] ?? '',
      unit: json['unit'] ?? '',
    );
  }
}
