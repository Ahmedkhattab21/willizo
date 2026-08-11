import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/workout/data/models/recipes_response_model.dart';
import 'package:willizo/features/workout/data/services/workout_api_endpoints.dart';

class RecipesServices {
  final ApiConsumer apiConsumer;

  RecipesServices(this.apiConsumer);

  Future<RecipesResponseModel> getRecipes() async {
    final response = await apiConsumer.get(
      WorkoutApiEndpoints.recipes,
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    return RecipesResponseModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<RecipeModel>> getFeaturedRecipes() async {
    final response = await apiConsumer.get(
      WorkoutApiEndpoints.featuredRecipes,
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    return RecipeModel.listFromJson(jsonDecode(response.body));
  }

  Future<List<RecipeModel>> getPopularRecipes() async {
    final response = await apiConsumer.get(
      WorkoutApiEndpoints.popularRecipes,
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    return RecipeModel.listFromJson(jsonDecode(response.body));
  }

  Future<List<RecipeModel>> getFavoriteRecipes() async {
    final response = await apiConsumer.get(
      WorkoutApiEndpoints.favoriteRecipes,
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    return RecipeModel.listFromJson(jsonDecode(response.body));
  }

  Future<RecipeModel> getRecipeDetails(String slug) async {
    final response = await apiConsumer.get(
      WorkoutApiEndpoints.recipeDetails(slug),
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    final decoded = jsonDecode(response.body);
    final data = decoded is Map<String, dynamic> && decoded['data'] is Map
        ? (decoded['data'] as Map).cast<String, dynamic>()
        : (decoded as Map).cast<String, dynamic>();
    return RecipeModel.fromJson(data);
  }

  Future<void> toggleRecipeFavorite(String slug) async {
    final response = await apiConsumer.post(
      WorkoutApiEndpoints.recipeFavorite(slug),
      {},
      await _authHeaders(),
    );
    _throwIfNotOk(response);
  }

  Future<void> addRecipeToMealPlan({
    required int recipeId,
    required String mealType,
    required String plannedDate,
  }) async {
    final response = await apiConsumer.post(WorkoutApiEndpoints.myMealPlans, {
      'recipe_id': recipeId,
      'meal_type': mealType,
      'planned_date': plannedDate,
    }, await _authHeaders());
    _throwIfNotOk(response);
  }

  Future<void> markMealAsCompleted(int mealPlanId) async {
    final response = await apiConsumer.post(
      WorkoutApiEndpoints.markMealCompleted(mealPlanId),
      {},
      await _authHeaders(),
    );
    _throwIfNotOk(response);
  }

  Future<void> removeFromMealPlan(int mealPlanId) async {
    final response = await apiConsumer.delete(
      WorkoutApiEndpoints.removeMealPlan(mealPlanId),
      null,
      await _authHeaders(),
    );
    _throwIfNotOk(response);
  }

  Future<Map<String, String>> _authHeaders() async {
    return {
      ConstantKeys.appAuthorization:
          '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
    };
  }

  void _throwIfNotOk(http.Response response) {
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return;
    }

    ServerFailure failure;
    try {
      final decoded = jsonDecode(response.body);
      failure = decoded is Map<String, dynamic>
          ? ServerFailure.fromJson(decoded)
          : ServerFailure(message: decoded.toString());
    } catch (_) {
      failure = ServerFailure(
        message: response.body.trim().isNotEmpty
            ? response.body.trim()
            : response.reasonPhrase ?? 'Unknown error',
      );
    }

    throw ServerException(serverFailure: failure);
  }
}
