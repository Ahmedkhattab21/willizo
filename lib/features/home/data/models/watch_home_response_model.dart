import 'package:willizo/features/home/data/models/my_meal_plans_response_model.dart';
import 'package:willizo/features/home/data/models/my_workout_plans_response_model.dart';

class WatchHomeResponseModel {
  final String date;
  final List<ScheduledWorkoutModel> workouts;
  final List<ScheduledMealModel> meals;
  final bool hasRecognizedHomeData;

  const WatchHomeResponseModel({
    required this.date,
    required this.workouts,
    required this.meals,
    required this.hasRecognizedHomeData,
  });

  factory WatchHomeResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']) ?? json;
    final today = _asMap(data['today']);

    final workoutValue = _firstValue(data, today, const [
      'workouts',
      'today_workouts',
      'todayWorkouts',
      'workout',
      'today_workout',
      'todayWorkout',
    ]);
    final mealValue = _firstValue(data, today, const [
      'meals',
      'today_meals',
      'todayMeals',
      'meal',
      'today_meal',
      'todayMeal',
    ]);

    final workoutMaps = _asMapList(workoutValue);
    final mealMaps = _asMapList(mealValue);

    return WatchHomeResponseModel(
      date: (data['date'] ?? today?['date'] ?? json['date'])?.toString() ?? '',
      workouts: workoutMaps.map(ScheduledWorkoutModel.fromJson).toList(),
      meals: mealMaps.map(ScheduledMealModel.fromJson).toList(),
      hasRecognizedHomeData: workoutValue != null || mealValue != null,
    );
  }
}

dynamic _firstValue(
  Map<String, dynamic> data,
  Map<String, dynamic>? nested,
  List<String> keys,
) {
  for (final key in keys) {
    if (data.containsKey(key)) return data[key];
    if (nested?.containsKey(key) == true) return nested![key];
  }
  return null;
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  return null;
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is List) {
    return value.map(_asMap).whereType<Map<String, dynamic>>().toList();
  }
  final single = _asMap(value);
  return single == null ? const [] : [single];
}
