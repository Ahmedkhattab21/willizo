class WorkoutResponseModel {
  final bool status;
  final String message;
  final List<WorkoutData> data;

  WorkoutResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WorkoutResponseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => WorkoutData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class WorkoutData {
  final int id;
  final String name;
  final String description;
  final String level;
  final int duration; // in minutes
  final String image;
  final List<ExerciseData> exercises;

  WorkoutData({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.duration,
    required this.image,
    required this.exercises,
  });

  factory WorkoutData.fromJson(Map<String, dynamic> json) {
    return WorkoutData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      level: json['level'] ?? '',
      duration: json['duration'] ?? 0,
      image: json['image'] ?? '',
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((item) => ExerciseData.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "level": level,
      "duration": duration,
      "image": image,
      "exercises": exercises.map((e) => e.toJson()).toList(),
    };
  }
}

class ExerciseData {
  final int id;
  final String name;
  final int sets;
  final int reps;
  final String image;

  ExerciseData({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.image,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      sets: json['sets'] ?? 0,
      reps: json['reps'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "sets": sets,
      "reps": reps,
      "image": image,
    };
  }
}
