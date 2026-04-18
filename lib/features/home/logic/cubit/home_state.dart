part of 'home_cubit.dart';

enum HomeLoadStatus { initial, loading, success, failure }

final class HomeState {
  final DateTime selectedDate;

  final HomeLoadStatus workoutPlansStatus;
  final HomeLoadStatus mealPlansStatus;

  final List<ScheduledWorkoutModel> workouts;
  final List<ScheduledMealModel> meals;

  final String? workoutPlansResponseDate;
  final String? mealPlansResponseDate;

  final String? workoutPlansError;
  final String? mealPlansError;

  const HomeState({
    required this.selectedDate,
    required this.workoutPlansStatus,
    required this.mealPlansStatus,
    required this.workouts,
    required this.meals,
    this.workoutPlansResponseDate,
    this.mealPlansResponseDate,
    this.workoutPlansError,
    this.mealPlansError,
  });

  factory HomeState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return HomeState(
      selectedDate: today,
      workoutPlansStatus: HomeLoadStatus.initial,
      mealPlansStatus: HomeLoadStatus.initial,
      workouts: const [],
      meals: const [],
    );
  }

  HomeState copyWith({
    DateTime? selectedDate,
    HomeLoadStatus? workoutPlansStatus,
    HomeLoadStatus? mealPlansStatus,
    List<ScheduledWorkoutModel>? workouts,
    List<ScheduledMealModel>? meals,
    String? workoutPlansResponseDate,
    String? mealPlansResponseDate,
    String? workoutPlansError,
    String? mealPlansError,
    bool clearWorkoutPlansError = false,
    bool clearMealPlansError = false,
  }) {
    return HomeState(
      selectedDate: selectedDate ?? this.selectedDate,
      workoutPlansStatus: workoutPlansStatus ?? this.workoutPlansStatus,
      mealPlansStatus: mealPlansStatus ?? this.mealPlansStatus,
      workouts: workouts ?? this.workouts,
      meals: meals ?? this.meals,
      workoutPlansResponseDate:
          workoutPlansResponseDate ?? this.workoutPlansResponseDate,
      mealPlansResponseDate: mealPlansResponseDate ?? this.mealPlansResponseDate,
      workoutPlansError:
          clearWorkoutPlansError ? null : (workoutPlansError ?? this.workoutPlansError),
      mealPlansError:
          clearMealPlansError ? null : (mealPlansError ?? this.mealPlansError),
    );
  }
}
