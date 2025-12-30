import 'dart:convert';
import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/wishlist/data/models/remove_wishlist_response.dart';
import 'package:willizo/features/wishlist/data/models/wishlist_response_model.dart';
import 'package:willizo/features/wishlist/data/services/wishlist_api_endpoints.dart';

class WishlistService {
  final ApiConsumer apiConsumer;

  WishlistService({required this.apiConsumer});

  Future<WishlistResponseModel> getWishlist() async {
    final response = await apiConsumer.get(WishlistApiEndpoints.wishlistUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return WishlistResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<RemoveWishlistResponse> removeFromWishlist({
    required String productId,
  }) async {
    final response = await apiConsumer.delete(
      WishlistApiEndpoints.removeFromWishlist(productId),
      null,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return RemoveWishlistResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
