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
}
