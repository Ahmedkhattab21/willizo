class MyWorkoutPlansResponseModel {
  final String date;
  final List<ScheduledWorkoutModel> workouts;

  MyWorkoutPlansResponseModel({
    required this.date,
    required this.workouts,
  });

  factory MyWorkoutPlansResponseModel.fromJson(Map<String, dynamic> json) {
    return MyWorkoutPlansResponseModel(
      date: json['date']?.toString() ?? '',
      workouts: (json['workouts'] as List<dynamic>?)
              ?.map((e) => ScheduledWorkoutModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ScheduledWorkoutModel {
  final int id;
  final String scheduledTime;
  final bool isCompleted;
  final WorkoutPlanModel workoutPlan;

  ScheduledWorkoutModel({
    required this.id,
    required this.scheduledTime,
    required this.isCompleted,
    required this.workoutPlan,
  });

  factory ScheduledWorkoutModel.fromJson(Map<String, dynamic> json) {
    final planJson = json['workout_plan'];
    return ScheduledWorkoutModel(
      id: _asInt(json['id']),
      scheduledTime: json['scheduled_time']?.toString() ?? '',
      isCompleted: json['is_completed'] == true,
      workoutPlan: planJson is Map<String, dynamic>
          ? WorkoutPlanModel.fromJson(planJson)
          : WorkoutPlanModel.empty(),
    );
  }
}

class WorkoutPlanModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String imageUrl;
  final String difficulty;
  final int? durationMinutes;
  final int? caloriesBurned;
  final String category;
  final bool isFeatured;
  final bool isActive;
  final List<String> equipmentNeeded;
  final List<WorkoutPlanExerciseModel> workoutPlanExercises;

  WorkoutPlanModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.difficulty,
    this.durationMinutes,
    this.caloriesBurned,
    required this.category,
    required this.isFeatured,
    required this.isActive,
    required this.equipmentNeeded,
    required this.workoutPlanExercises,
  });

  factory WorkoutPlanModel.empty() {
    return WorkoutPlanModel(
      id: 0,
      name: '',
      slug: '',
      description: '',
      imageUrl: '',
      difficulty: '',
      durationMinutes: null,
      caloriesBurned: null,
      category: '',
      isFeatured: false,
      isActive: false,
      equipmentNeeded: const [],
      workoutPlanExercises: const [],
    );
  }

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      difficulty: json['difficulty']?.toString() ?? '',
      durationMinutes: _asNullableInt(json['duration']),
      caloriesBurned: _asNullableInt(json['calories_burned']),
      category: json['category']?.toString() ?? '',
      isFeatured: json['is_featured'] == true,
      isActive: json['is_active'] != false,
      equipmentNeeded: (json['equipment_needed'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      workoutPlanExercises: (json['workout_plan_exercises'] as List<dynamic>?)
              ?.map((e) => WorkoutPlanExerciseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class WorkoutPlanExerciseModel {
  final int id;
  final int workoutPlanId;
  final String exerciseId;
  final int? sets;
  final int? reps;
  final int? duration;
  final int? restTime;
  final int order;
  final ExerciseModel exercise;

  WorkoutPlanExerciseModel({
    required this.id,
    required this.workoutPlanId,
    required this.exerciseId,
    this.sets,
    this.reps,
    this.duration,
    this.restTime,
    required this.order,
    required this.exercise,
  });

  factory WorkoutPlanExerciseModel.fromJson(Map<String, dynamic> json) {
    final ex = json['exercise'];
    return WorkoutPlanExerciseModel(
      id: _asInt(json['id']),
      workoutPlanId: _asInt(json['workout_plan_id']),
      exerciseId: json['exercise_id']?.toString() ?? '',
      sets: _asNullableInt(json['sets']),
      reps: _asNullableInt(json['reps']),
      duration: _asNullableInt(json['duration']),
      restTime: _asNullableInt(json['rest_time']),
      order: _asInt(json['order']),
      exercise: ex is Map<String, dynamic>
          ? ExerciseModel.fromJson(ex)
          : ExerciseModel.empty(),
    );
  }
}

class ExerciseModel {
  final String id;
  final String name;
  final String slug;
  final String icon;
  final String description;
  final String category;
  final String unit;
  final bool isActive;
  final int sortOrder;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.description,
    required this.category,
    required this.unit,
    required this.isActive,
    required this.sortOrder,
  });

  factory ExerciseModel.empty() {
    return ExerciseModel(
      id: '',
      name: '',
      slug: '',
      icon: '',
      description: '',
      category: '',
      unit: '',
      isActive: false,
      sortOrder: 0,
    );
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      isActive: json['is_active'] != false,
      sortOrder: _asInt(json['sort_order']),
    );
  }
}

int _asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

int? _asNullableInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString());
}
