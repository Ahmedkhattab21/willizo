import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/all_products/data/models/all_products_model_response.dart';
import 'package:willizo/features/all_products/data/services/all_products_service.dart';

class AllProductsRepo {
  final AllProductsService _allProductsService;

  AllProductsRepo(this._allProductsService);

  Future<Either<Failure, AllProductsResponseModel>> getAllProducts({
    int? page,
  }) async {
    try {
      return Right(await _allProductsService.getAllProducts(page: page));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
