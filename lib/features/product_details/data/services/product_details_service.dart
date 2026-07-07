import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/product_details/data/services/product_details_api_endpoints.dart';
import 'package:willizo/features/product_details/data/models/add_product_to_cart_request_response.dart';
import 'package:willizo/features/product_details/data/models/add_product_to_wishlist_response.dart';
import 'package:willizo/features/product_details/data/models/create_review_request_model.dart';
import 'package:willizo/features/product_details/data/models/product_added_to_cart_response.dart';
import 'package:willizo/features/product_details/data/models/product_details_response_model.dart';
import 'package:willizo/features/product_details/data/models/product_reviews_response_model.dart';
import 'package:willizo/features/shop/data/models/shop_model_response.dart';

class ProductDetailsService {
  ApiConsumer apiConsumer;

  ProductDetailsService({required this.apiConsumer});

  Future<AddProductToWishlistResponse> addProductToWishlist(
    String productId,
  ) async {
    final response = await apiConsumer.post(
      ProductDetailsApiEndpoints.addProductToWishlist,
      {'product_id': productId},
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return AddProductToWishlistResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    final response = await apiConsumer.delete(
      ProductDetailsApiEndpoints.removeFromWishlist(productId),
      null,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode != StatusCode.ok &&
        response.statusCode != StatusCode.created &&
        response.statusCode != StatusCode.noContent) {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<ProductAddedToCartResponse> addProductToCart(
    AddProductToCartRequest request,
  ) async {
    final response = await apiConsumer.post(
      ProductDetailsApiEndpoints.addProductToCart,
      request.toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ProductAddedToCartResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<ProductDetailsResponseModel> getProductDetails(
    String productId,
  ) async {
    final response = await apiConsumer.get(
      ProductDetailsApiEndpoints.getProductDetails(productId),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ProductDetailsResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<ProductReviewsResponseModel> getProductReviews(
    String productId,
  ) async {
    final response = await apiConsumer.get(
      ProductDetailsApiEndpoints.getProductReviews(productId),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ProductReviewsResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<void> createReview(CreateReviewRequestModel request) async {
    final response = await apiConsumer.post(
      ProductDetailsApiEndpoints.createReview,
      request.toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode != StatusCode.ok &&
        response.statusCode != StatusCode.created) {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<ShopResponseModel> getRelatedProducts(String productSlug) async {
    final response = await apiConsumer.get(
      ProductDetailsApiEndpoints.getRelatedProducts(productSlug),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ShopResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
