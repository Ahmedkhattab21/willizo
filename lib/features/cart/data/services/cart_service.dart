import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';
import 'package:willizo/features/cart/data/models/checkout_calculation_response_model.dart';
import 'package:willizo/features/cart/data/models/clear_cart_response.dart';
import 'package:willizo/features/cart/data/models/delete_cart_item_response.dart';
import 'package:willizo/features/cart/data/models/update_cart_count_response.dart';
import 'package:willizo/features/cart/data/services/cart_api_endpoints.dart';

class CartService {
  final ApiConsumer apiConsumer;

  CartService({required this.apiConsumer});

  Future<CartResponseModel> getCart() async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    final refreshToken = await CacheHelper.getSecuredString(
      ConstantKeys.saveRefreshTokenToShared,
    );
    debugPrint('🛒 [Cart API] Calling: ${CartApiEndpoints.cartUrl}');

    final response = await apiConsumer.get(CartApiEndpoints.cartUrl, {
      ConstantKeys.appAuthorization: "${ConstantKeys.appBearer} $token",
    });

    debugPrint('🛒 [Cart API] Response Status: ${response.statusCode}');
    debugPrint('🛒 [Cart API] Response Body: ${response.body}');

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

  Future<CheckoutCalculationResponseModel> calculateCheckout({
    required int addressId,
    required String shippingMethod,
  }) async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    debugPrint(
      '🛒 [Checkout Calculate API] Calling: ${CartApiEndpoints.checkoutCalculateUrl}',
    );
    debugPrint(
      '🛒 [Checkout Calculate API] Body: {"address_id": $addressId, "shipping_method": "$shippingMethod"}',
    );

    final response = await apiConsumer.post(
      CartApiEndpoints.checkoutCalculateUrl,
      {'address_id': addressId, 'shipping_method': shippingMethod},
      {
        ConstantKeys.appAuthorization: "${ConstantKeys.appBearer} $token",
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    debugPrint(
      '🛒 [Checkout Calculate API] Response Status: ${response.statusCode}',
    );
    debugPrint('🛒 [Checkout Calculate API] Response Body: ${response.body}');

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return CheckoutCalculationResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
