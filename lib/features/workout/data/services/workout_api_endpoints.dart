import 'package:willizo/core/api/end_points.dart';

class WorkoutApiEndpoints {
  static const String recipes = '${EndPoints.baseUrl}/recipes';
  static const String featuredRecipes = '${EndPoints.baseUrl}/recipes/featured';
  static const String popularRecipes = '${EndPoints.baseUrl}/recipes/popular';
  static const String favoriteRecipes =
      '${EndPoints.baseUrl}/recipes/favorites';
  static const String myMealPlans = '${EndPoints.baseUrl}/my-meal-plans';
  static const String bodyParts = '${EndPoints.baseUrl}/body-parts';

  static String recipeDetails(String slug) =>
      '${EndPoints.baseUrl}/recipes/$slug';

  static String recipeFavorite(String slug) =>
      '${EndPoints.baseUrl}/recipes/$slug/favorite';

  static String recipesByCategory(String category) =>
      '${EndPoints.baseUrl}/recipes/category/$category';

  static String markMealCompleted(int mealPlanId) =>
      '$myMealPlans/$mealPlanId/complete';

  static String removeMealPlan(int mealPlanId) => '$myMealPlans/$mealPlanId';
}
