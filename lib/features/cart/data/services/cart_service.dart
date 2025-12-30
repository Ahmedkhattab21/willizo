import 'dart:convert';
import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';
import 'package:willizo/features/cart/data/models/clear_cart_response.dart';
import 'package:willizo/features/cart/data/models/delete_cart_item_response.dart';
import 'package:willizo/features/cart/data/models/update_cart_count_response.dart';
import 'package:willizo/features/cart/data/services/cart_api_endpoints.dart';

class CartService {
  final ApiConsumer apiConsumer;

  CartService({required this.apiConsumer});

  Future<CartResponseModel> getCart() async {
    final response = await apiConsumer.get(CartApiEndpoints.cartUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return CartResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<UpdateCartCountResponse> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    final response = await apiConsumer.put(
      CartApiEndpoints.updateCartItemQuantity(cartItemId),
      {'quantity': quantity},
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return UpdateCartCountResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<ClearCartResponse> clearCart() async {
    final response = await apiConsumer.delete(
      CartApiEndpoints.deleteAllCartItems,
      null,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ClearCartResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<DeleteCartItemResponse> deleteCartItem({
    required String cartItemId,
  }) async {
    final response = await apiConsumer.delete(
      CartApiEndpoints.deleteCartItem(cartItemId),
      null,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return DeleteCartItemResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
