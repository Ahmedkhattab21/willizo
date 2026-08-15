import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/account/data/models/account_resonse.dart';
import 'package:willizo/features/home/data/models/home_model.dart';
import 'package:willizo/features/home/data/models/my_meal_plans_response_model.dart';
import 'package:willizo/features/home/data/models/my_workout_plans_response_model.dart';
import 'package:willizo/features/home/data/models/watch_home_response_model.dart';
import 'package:willizo/features/home/data/services/home_services.dart';

class HomeRepo {
  final HomeServices homeServices;

  HomeRepo(this.homeServices);

  Future<Either<Failure, HomeResponseModel>> getHome() async {
    try {
      return Right(await homeServices.getHome());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, AccountResponseModel>> getProfile() async {
    try {
      return Right(await homeServices.getProfile());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, WatchHomeResponseModel>> getWatchHome() async {
    try {
      return Right(await homeServices.getWatchHome());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, MyWorkoutPlansResponseModel>>
  getTodayWorkoutPlans() async {
    try {
      return Right(await homeServices.getTodayWorkoutPlans());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, MyMealPlansResponseModel>> getTodayMealPlans() async {
    try {
      return Right(await homeServices.getTodayMealPlans());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, MyWorkoutPlansResponseModel>> getWorkoutPlansByDate(
    String date,
  ) async {
    try {
      return Right(await homeServices.getWorkoutPlansByDate(date));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, MyMealPlansResponseModel>> getMealPlansByDate(
    String date,
  ) async {
    try {
      return Right(await homeServices.getMealPlansByDate(date));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
