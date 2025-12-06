import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/product_details/data/services/product_details_service.dart';
import 'package:willizo/features/shop/data/models/shop_model_response.dart';

class ProductDetailsRepo {
  final ProductDetailsService _productDetailsService;

  ProductDetailsRepo(this._productDetailsService);

  Future<Either<Failure, ShopResponseModel>> getRelatedProducts(
    String productSlug,
  ) async {
    try {
      return Right(
        await _productDetailsService.getRelatedProducts(productSlug),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
