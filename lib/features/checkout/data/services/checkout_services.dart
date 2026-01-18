import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/checkout/data/models/address_model.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_request_model.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_response_model.dart';
import 'package:willizo/features/checkout/data/models/create_address_request_model.dart';
import 'package:willizo/features/checkout/data/models/create_address_response_model.dart';
import 'package:willizo/features/checkout/data/models/order_response_model.dart';
import 'package:willizo/features/checkout/data/services/checkout_api_endpoints.dart';

class CheckoutService {
  final ApiConsumer apiConsumer;

  CheckoutService({required this.apiConsumer});

  Future<AddressResponseModel> getAddresses() async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    debugPrint('📍 [Addresses API] Access Token: $token');
    debugPrint(
      '📍 [Addresses API] Calling: ${CheckoutApiEndpoints.addressesUrl}',
    );

    final response = await apiConsumer.get(CheckoutApiEndpoints.addressesUrl, {
      ConstantKeys.appAuthorization: "${ConstantKeys.appBearer} $token",
    });

    debugPrint('📍 [Addresses API] Response Status: ${response.statusCode}');
    debugPrint('📍 [Addresses API] Response Body: ${response.body}');

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return AddressResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<CreateAddressResponseModel> createAddress(
    CreateAddressRequestModel request,
  ) async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    debugPrint('📍 [Create Address API] Access Token: $token');
    debugPrint(
      '📍 [Create Address API] Calling: ${CheckoutApiEndpoints.addressesUrl}',
    );
    debugPrint(
      '📍 [Create Address API] Body: ${request.toJson()}',
    );

    final response = await apiConsumer.post(
      CheckoutApiEndpoints.addressesUrl,
      request.toJson(),
      {
        ConstantKeys.appAuthorization: "${ConstantKeys.appBearer} $token",
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    debugPrint(
      '📍 [Create Address API] Response Status: ${response.statusCode}',
    );
    debugPrint('📍 [Create Address API] Response Body: ${response.body}');

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return CreateAddressResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<CheckoutCalculationResponseModel> calculateCheckout(
    CheckoutCalculationRequestModel request,
  ) async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    debugPrint('📍 [Calculate Checkout API] Access Token: $token');
    debugPrint(
      '📍 [Calculate Checkout API] Calling: ${CheckoutApiEndpoints.checkoutCalculateUrl}',
    );
    debugPrint(
      '📍 [Calculate Checkout API] Body: ${request.toJson()}',
    );

    final response = await apiConsumer.post(
      CheckoutApiEndpoints.checkoutCalculateUrl,
      request.toJson(),
      {
        ConstantKeys.appAuthorization: "${ConstantKeys.appBearer} $token",
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    debugPrint(
      '📍 [Calculate Checkout API] Response Status: ${response.statusCode}',
    );
    debugPrint('📍 [Calculate Checkout API] Response Body: ${response.body}');

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

  Future<OrderResponseModel> confirmCheckout() async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    debugPrint('📍 [Confirm Checkout API] Access Token: $token');
    debugPrint(
      '📍 [Confirm Checkout API] Calling: ${CheckoutApiEndpoints.confirmCheckoutUrl}',
    );

    final response = await apiConsumer.post(
      CheckoutApiEndpoints.confirmCheckoutUrl,
      {}, // Empty body - server already has cart and address info from previous calls
      {
        ConstantKeys.appAuthorization: "${ConstantKeys.appBearer} $token",
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    debugPrint(
      '📍 [Confirm Checkout API] Response Status: ${response.statusCode}',
    );
    debugPrint('📍 [Confirm Checkout API] Response Body: ${response.body}');

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return OrderResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
