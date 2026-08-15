import 'package:willizo/core/api/end_points.dart';

class HomeApiEndpoints {
  static const String homeUrl = '${EndPoints.baseUrl}api/home';
  static const String watchHome = '${EndPoints.baseUrl}/watch/home';

  static const String _workoutBase = '${EndPoints.baseUrl}/my-workout-plans';
  static const String _mealBase = '${EndPoints.baseUrl}/my-meal-plans';

  static const String workoutPlansToday = '$_workoutBase/today';
  static const String mealPlansToday = '$_mealBase/today';

  static String workoutPlansByDate(String date) => '$_workoutBase?date=$date';
  static String mealPlansByDate(String date) => '$_mealBase?date=$date';
}
