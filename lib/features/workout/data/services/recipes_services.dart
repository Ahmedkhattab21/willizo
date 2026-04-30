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
