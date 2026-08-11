import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/workout/data/models/recipes_response_model.dart';
import 'package:willizo/features/workout/data/services/recipes_services.dart';

class RecipesRepo {
  final RecipesServices recipesServices;

  RecipesRepo(this.recipesServices);

  Future<Either<Failure, RecipesResponseModel>> getRecipes() async {
    try {
      return Right(await recipesServices.getRecipes());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, List<RecipeModel>>> getFeaturedRecipes() async {
    try {
      return Right(await recipesServices.getFeaturedRecipes());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, List<RecipeModel>>> getPopularRecipes() async {
    try {
      return Right(await recipesServices.getPopularRecipes());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, List<RecipeModel>>> getFavoriteRecipes() async {
    try {
      return Right(await recipesServices.getFavoriteRecipes());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, RecipeModel>> getRecipeDetails(String slug) async {
    try {
      return Right(await recipesServices.getRecipeDetails(slug));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, void>> toggleRecipeFavorite(String slug) async {
    try {
      await recipesServices.toggleRecipeFavorite(slug);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, void>> addRecipeToMealPlan({
    required int recipeId,
    required String mealType,
    required String plannedDate,
  }) async {
    try {
      await recipesServices.addRecipeToMealPlan(
        recipeId: recipeId,
        mealType: mealType,
        plannedDate: plannedDate,
      );
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, void>> markMealAsCompleted(int mealPlanId) async {
    try {
      await recipesServices.markMealAsCompleted(mealPlanId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, void>> removeFromMealPlan(int mealPlanId) async {
    try {
      await recipesServices.removeFromMealPlan(mealPlanId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
