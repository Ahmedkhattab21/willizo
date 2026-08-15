import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:willizo/core/api/end_points.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/home/data/models/my_meal_plans_response_model.dart';
import 'package:willizo/features/home/data/models/my_workout_plans_response_model.dart';

class WatchWorkoutSyncService {
  static const MethodChannel _channel = MethodChannel('willizo/watch_workout');
  static Future<void> Function()? _refreshHandler;
  static bool _isInitialized = false;

  const WatchWorkoutSyncService._();

  static void initialize() {
    if (defaultTargetPlatform != TargetPlatform.iOS || _isInitialized) return;
    _isInitialized = true;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'refreshTodayWorkout':
          await _refreshHandler?.call();
        case 'requestAuthSession':
          return _authenticationPayload();
        case 'authSessionUpdated':
          final arguments = Map<String, dynamic>.from(call.arguments as Map);
          await _storeAuthenticationPayload(arguments);
      }
    });
  }

  static void registerRefreshHandler(Future<void> Function() handler) {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    initialize();
    _refreshHandler = handler;
  }

  static Future<void> syncAuthenticationSession({
    String? accessToken,
    String? refreshToken,
    String tokenType = 'bearer',
    int? expiresIn,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    final payload = await _authenticationPayload(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
    );
    if (payload == null) return;
    try {
      await _channel.invokeMethod<void>('updateAuthSession', payload);
    } on PlatformException {
      // The phone remains the source of truth and retries on the next launch.
    } on MissingPluginException {
      // Tests and non-iOS platforms do not register the native bridge.
    }
  }

  static Future<void> clearAuthenticationSession() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      await _channel.invokeMethod<void>('clearAuthSession');
    } on PlatformException {
      // Logout on the phone must continue even if the watch is unavailable.
    } on MissingPluginException {
      // Tests and non-iOS platforms do not register the native bridge.
    }
  }

  static Future<Map<String, dynamic>?> _authenticationPayload({
    String? accessToken,
    String? refreshToken,
    String tokenType = 'bearer',
    int? expiresIn,
  }) async {
    final currentAccessToken =
        accessToken ??
        await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared);
    final currentRefreshToken =
        refreshToken ??
        await CacheHelper.getSecuredString(
          ConstantKeys.saveRefreshTokenToShared,
        );
    if (currentAccessToken.isEmpty || currentRefreshToken.isEmpty) return null;
    return {
      'accessToken': currentAccessToken,
      'refreshToken': currentRefreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'baseURL': EndPoints.baseUrl,
    };
  }

  static Future<void> _storeAuthenticationPayload(
    Map<String, dynamic> payload,
  ) async {
    final accessToken = payload['accessToken']?.toString() ?? '';
    final refreshToken = payload['refreshToken']?.toString() ?? '';
    if (accessToken.isNotEmpty) {
      await CacheHelper.setSecuredString(
        ConstantKeys.saveTokenToShared,
        accessToken,
      );
    }
    if (refreshToken.isNotEmpty) {
      await CacheHelper.setSecuredString(
        ConstantKeys.saveRefreshTokenToShared,
        refreshToken,
      );
    }
  }

  static void unregisterRefreshHandler() {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    _refreshHandler = null;
  }

  static Future<void> syncTodayWorkouts({
    required DateTime selectedDate,
    required List<ScheduledWorkoutModel> workouts,
    required List<ScheduledMealModel> meals,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;

    final selectedWorkout = _selectWorkout(workouts);
    final payload = <String, dynamic>{
      'schemaVersion': 1,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
      'date': _formatDate(selectedDate),
      'workout': selectedWorkout == null
          ? null
          : _scheduledWorkoutToJson(selectedWorkout),
      'meals': meals.map(_mealToJson).toList(),
    };

    try {
      await _channel.invokeMethod<void>('updateTodayWorkout', payload);
    } on PlatformException {
      // Watch sync is non-critical. The phone app must continue normally.
    } on MissingPluginException {
      // Android and tests do not register the iOS channel.
    }
  }

  static ScheduledWorkoutModel? _selectWorkout(
    List<ScheduledWorkoutModel> workouts,
  ) {
    if (workouts.isEmpty) return null;
    return workouts.firstWhere(
      (workout) => !workout.isCompleted,
      orElse: () => workouts.first,
    );
  }

  static Map<String, dynamic> _scheduledWorkoutToJson(
    ScheduledWorkoutModel workout,
  ) {
    final plan = workout.workoutPlan;
    final exercises = [...plan.workoutPlanExercises]
      ..sort((a, b) => a.order.compareTo(b.order));

    return {
      'scheduledWorkoutId': workout.id,
      'scheduledTime': workout.scheduledTime,
      'isCompleted': workout.isCompleted,
      'plan': {
        'id': plan.id,
        'name': plan.name,
        'slug': plan.slug,
        'difficulty': plan.difficulty,
        'category': plan.category,
        'durationMinutes': plan.durationMinutes,
        'caloriesBurned': plan.caloriesBurned,
        'exercises': exercises.map(_exerciseToJson).toList(),
      },
    };
  }

  static Map<String, dynamic> _exerciseToJson(
    WorkoutPlanExerciseModel planExercise,
  ) {
    return {
      'id': planExercise.id,
      'exerciseId': planExercise.exerciseId,
      'name': planExercise.exercise.name,
      'sets': planExercise.sets ?? 0,
      'reps': planExercise.reps ?? 0,
      'weight': null,
      'previousSet': null,
      'restSeconds': planExercise.restTime ?? 60,
      'order': planExercise.order,
      'unit': planExercise.exercise.unit,
      'category': planExercise.exercise.category,
    };
  }

  static Map<String, dynamic> _mealToJson(ScheduledMealModel meal) {
    return {
      'id': meal.id,
      'mealType': meal.mealType,
      'name': meal.recipe.name,
      'calories': meal.recipe.calories,
      'isCompleted': meal.isCompleted,
    };
  }

  static String _formatDate(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }
}
