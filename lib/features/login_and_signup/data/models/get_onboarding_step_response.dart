class GetOnboardingStepResponseModel {
  final bool success;
  final String message;
  final OnboardingData data;

  GetOnboardingStepResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetOnboardingStepResponseModel.fromJson(Map<String, dynamic> json) {
    return GetOnboardingStepResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: OnboardingData.fromJson(json['data'] ?? {}),
    );
  }
}

class OnboardingData {
  final int currentStep;
  final int totalSteps;
  final Map<String, Answer> answers;
  final bool isCompleted;
  final double progressPercentage;
  final String createdAt;
  final String updatedAt;

  OnboardingData({
    required this.currentStep,
    required this.totalSteps,
    required this.answers,
    required this.isCompleted,
    required this.progressPercentage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    Map<String, Answer> answersMap = {};
    if (json['answers'] != null) {
      (json['answers'] as Map<String, dynamic>).forEach((key, value) {
        answersMap[key] = Answer.fromJson(value);
      });
    }

    return OnboardingData(
      currentStep: json['current_step'] ?? 1,
      totalSteps: json['total_steps'] ?? 21,
      answers: answersMap,
      isCompleted: json['is_completed'] ?? false,
      progressPercentage: (json['progress_percentage'] ?? 0.0).toDouble(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class Answer {
  final String fitnessGoal;
  final String experienceLevel;
  final int workoutFrequency;
  final int workoutDuration;

  Answer({
    required this.fitnessGoal,
    required this.experienceLevel,
    required this.workoutFrequency,
    required this.workoutDuration,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      fitnessGoal: json['fitness_goal'] ?? '',
      experienceLevel: json['experience_level'] ?? '',
      workoutFrequency: json['workout_frequency'] ?? 0,
      workoutDuration: json['workout_duration'] ?? 0,
    );
  }
}
