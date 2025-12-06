class FitnessPreferencesRequestModel {
  final int step;
  final String fitnessGoal;
  final String experienceLevel;
  final int workoutFrequency;
  final int workoutDuration;

  FitnessPreferencesRequestModel({
    required this.step,
    required this.fitnessGoal,
    required this.experienceLevel,
    required this.workoutFrequency,
    required this.workoutDuration,
  });

  Map<String, dynamic> toJson() {
    return {
      "step": step,
      "answer": {
        "fitness_goal": fitnessGoal,
        "experience_level": experienceLevel,
        "workout_frequency": workoutFrequency,
        "workout_duration": workoutDuration,
      },
    };
  }
}
