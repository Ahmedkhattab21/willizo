import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/all_products/data/models/all_products_model_response.dart';
import 'package:willizo/features/shop/data/models/categories_model_response.dart';
import 'package:willizo/features/shop/data/models/shop_model_response.dart';
import 'package:willizo/features/shop/data/services/shop_service.dart';

class ShopRepo {
  final ShopService _shopService;

  ShopRepo(this._shopService);

  Future<Either<Failure, ShopResponseModel>> getFeaturedProducts() async {
    try {
      return Right(await _shopService.getFeaturedProducts());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, CategoriesResponseModel>> getCategories() async {
    try {
      return Right(await _shopService.getCategories());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, AllProductsResponseModel>> getCategoryProducts(
    String categorySlug,
  ) async {
    try {
      return Right(await _shopService.getCategoryProducts(categorySlug));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
