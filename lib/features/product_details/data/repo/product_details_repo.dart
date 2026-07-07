import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/product_details/data/models/add_product_to_cart_request_response.dart';
import 'package:willizo/features/product_details/data/models/add_product_to_wishlist_response.dart';
import 'package:willizo/features/product_details/data/models/create_review_request_model.dart';
import 'package:willizo/features/product_details/data/models/product_added_to_cart_response.dart';
import 'package:willizo/features/product_details/data/models/product_details_response_model.dart';
import 'package:willizo/features/product_details/data/models/product_reviews_response_model.dart';
import 'package:willizo/features/product_details/data/services/product_details_service.dart';
import 'package:willizo/features/shop/data/models/shop_model_response.dart';

class ProductDetailsRepo {
  final ProductDetailsService _productDetailsService;

  ProductDetailsRepo(this._productDetailsService);

  Future<Either<Failure, AddProductToWishlistResponse>> addProductToWishlist(
    String productId,
  ) async {
    try {
      return Right(
        await _productDetailsService.addProductToWishlist(productId),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, void>> removeFromWishlist(String productId) async {
    try {
      return Right(await _productDetailsService.removeFromWishlist(productId));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, ProductAddedToCartResponse>> addProductToCart(
    AddProductToCartRequest request,
  ) async {
    try {
      return Right(await _productDetailsService.addProductToCart(request));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, ProductDetailsResponseModel>> getProductDetails(
    String productId,
  ) async {
    try {
      return Right(await _productDetailsService.getProductDetails(productId));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, ProductReviewsResponseModel>> getProductReviews(
    String productId,
  ) async {
    try {
      return Right(await _productDetailsService.getProductReviews(productId));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, void>> createReview(
    CreateReviewRequestModel request,
  ) async {
    try {
      return Right(await _productDetailsService.createReview(request));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

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
