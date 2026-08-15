import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/account/data/models/account_resonse.dart';
import 'package:willizo/features/account/data/services/account_api_endpoint.dart';
import 'package:willizo/features/home/data/models/home_model.dart';
import 'package:willizo/features/home/data/models/my_meal_plans_response_model.dart';
import 'package:willizo/features/home/data/models/my_workout_plans_response_model.dart';
import 'package:willizo/features/home/data/models/watch_home_response_model.dart';
import 'package:willizo/features/home/data/services/home_api_endpoints.dart';

class HomeServices {
  final ApiConsumer apiConsumer;
  HomeServices(this.apiConsumer);

  Future<HomeResponseModel> getHome() async {
    final response = await apiConsumer.get(HomeApiEndpoints.homeUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });
    return HomeResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<AccountResponseModel> getProfile() async {
    final response = await apiConsumer.get(
      AccountApiEndpoint.account,
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    return AccountResponseModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<WatchHomeResponseModel> getWatchHome() async {
    final response = await apiConsumer.get(
      HomeApiEndpoints.watchHome,
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    return WatchHomeResponseModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<MyWorkoutPlansResponseModel> getTodayWorkoutPlans() async {
    final response = await apiConsumer.get(
      HomeApiEndpoints.workoutPlansToday,
      await _authHeaders(),
    );
    _throwIfNotOk(response);

    return MyWorkoutPlansResponseModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<MyMealPlansResponseModel> getTodayMealPlans() async {
    final response = await apiConsumer.get(
      HomeApiEndpoints.mealPlansToday,
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    return MyMealPlansResponseModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<MyWorkoutPlansResponseModel> getWorkoutPlansByDate(String date) async {
    final response = await apiConsumer.get(
      HomeApiEndpoints.workoutPlansByDate(date),
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    return MyWorkoutPlansResponseModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<MyMealPlansResponseModel> getMealPlansByDate(String date) async {
    final response = await apiConsumer.get(
      HomeApiEndpoints.mealPlansByDate(date),
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    return MyMealPlansResponseModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Map<String, String>> _authHeaders() async {
    return {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    };
  }

  void _throwIfNotOk(http.Response response) {
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return;
    }

    try {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    } catch (_) {
      throw const ServerException(
        serverFailure: ServerFailure(message: 'Unknown error'),
      );
    }
  }
}
