import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:willizo/core/services/watch_workout_sync_service.dart';
import 'package:willizo/features/account/data/models/account_resonse.dart';
import 'package:willizo/features/home/data/models/my_meal_plans_response_model.dart';
import 'package:willizo/features/home/data/models/my_workout_plans_response_model.dart';
import 'package:willizo/features/home/data/repo/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepo) : super(HomeState.initial()) {
    WatchWorkoutSyncService.registerRefreshHandler(fetchPlans);
  }

  final HomeRepo homeRepo;

  Future<void> fetchPlans() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    await Future.wait([
      _fetchProfile(),
      _fetchPlansForDate(date: state.selectedDate, today: today),
    ]);
  }

  Future<void> _fetchProfile() async {
    emit(
      state.copyWith(
        profileStatus: HomeLoadStatus.loading,
        clearProfileError: true,
      ),
    );

    final result = await homeRepo.getProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(
          profileStatus: HomeLoadStatus.failure,
          profileError: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          profileStatus: HomeLoadStatus.success,
          accountData: response.data,
          clearProfileError: true,
        ),
      ),
    );
  }

  Future<void> selectDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    emit(state.copyWith(selectedDate: normalized));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    await _fetchPlansForDate(date: normalized, today: today);
  }

  Future<void> _fetchPlansForDate({
    required DateTime date,
    required DateTime today,
  }) async {
    emit(
      state.copyWith(
        workoutPlansStatus: HomeLoadStatus.loading,
        mealPlansStatus: HomeLoadStatus.loading,
        workouts: const [],
        meals: const [],
        clearWorkoutPlansError: true,
        clearMealPlansError: true,
      ),
    );

    final isToday = date == today;
    final dateParam = _formatDateParam(date);

    final workoutFuture = isToday
        ? homeRepo.getTodayWorkoutPlans()
        : homeRepo.getWorkoutPlansByDate(dateParam);
    final mealFuture = isToday
        ? homeRepo.getTodayMealPlans()
        : homeRepo.getMealPlansByDate(dateParam);

    final workoutResult = await workoutFuture;
    final mealResult = await mealFuture;

    HomeLoadStatus workoutStatus = HomeLoadStatus.initial;
    HomeLoadStatus mealStatus = HomeLoadStatus.initial;
    List<ScheduledWorkoutModel> workouts = const [];
    List<ScheduledMealModel> meals = const [];
    String? workoutDate;
    String? mealDate;
    String? workoutErr;
    String? mealErr;

    workoutResult.fold(
      (failure) {
        workoutStatus = HomeLoadStatus.failure;
        workoutErr = failure.message;
        workouts = const [];
      },
      (data) {
        workoutStatus = HomeLoadStatus.success;
        workouts = data.workouts;
        workoutDate = data.date.isNotEmpty ? data.date : null;
      },
    );

    mealResult.fold(
      (failure) {
        mealStatus = HomeLoadStatus.failure;
        mealErr = failure.message;
        meals = const [];
      },
      (data) {
        mealStatus = HomeLoadStatus.success;
        meals = data.meals;
        mealDate = data.date.isNotEmpty ? data.date : null;
      },
    );

    emit(
      HomeState(
        selectedDate: state.selectedDate,
        profileStatus: state.profileStatus,
        accountData: state.accountData,
        workoutPlansStatus: workoutStatus,
        mealPlansStatus: mealStatus,
        workouts: workouts,
        meals: meals,
        workoutPlansResponseDate: workoutStatus == HomeLoadStatus.success
            ? workoutDate
            : null,
        mealPlansResponseDate: mealStatus == HomeLoadStatus.success
            ? mealDate
            : null,
        workoutPlansError: workoutStatus == HomeLoadStatus.failure
            ? workoutErr
            : null,
        mealPlansError: mealStatus == HomeLoadStatus.failure ? mealErr : null,
        profileError: state.profileError,
      ),
    );

    if (isToday && defaultTargetPlatform == TargetPlatform.iOS) {
      var watchWorkouts = workouts;
      var watchMeals = meals;
      var canSync =
          workoutStatus == HomeLoadStatus.success ||
          mealStatus == HomeLoadStatus.success;

      final watchHomeResult = await homeRepo.getWatchHome();
      watchHomeResult.fold((_) {}, (watchHome) {
        if (!watchHome.hasRecognizedHomeData) return;
        watchWorkouts = watchHome.workouts;
        watchMeals = watchHome.meals;
        canSync = true;
      });

      if (canSync) {
        await WatchWorkoutSyncService.syncTodayWorkouts(
          selectedDate: date,
          workouts: watchWorkouts,
          meals: watchMeals,
        );
      }
    }
  }

  @override
  Future<void> close() {
    WatchWorkoutSyncService.unregisterRefreshHandler();
    return super.close();
  }

  String _formatDateParam(DateTime date) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }
}
