import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/my_order/data/models/orders_response_model.dart';
import 'package:willizo/features/my_order/data/services/orders_api_endpoints.dart';

class OrdersService {
  final ApiConsumer apiConsumer;

  OrdersService({required this.apiConsumer});

  Future<OrdersResponseModel> getOrders() async {
    final response = await apiConsumer.get(
      OrdersApiEndpoints.orders,
      await _authHeaders(),
    );

    if (_isSuccess(response.statusCode)) {
      return OrdersResponseModel.fromJson(jsonDecode(response.body));
    }

    throw ServerException(
      serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
    );
  }

  Future<OrderDetailsResponseModel> getOrderDetails(String orderId) async {
    final response = await apiConsumer.get(
      OrdersApiEndpoints.orderDetails(orderId),
      await _authHeaders(),
    );

    if (_isSuccess(response.statusCode)) {
      return OrderDetailsResponseModel.fromJson(jsonDecode(response.body));
    }

    throw ServerException(
      serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
    );
  }

  Future<String> cancelOrder(String orderId) async {
    final response = await apiConsumer.post(
      OrdersApiEndpoints.cancelOrder(orderId),
      {},
      await _authHeaders(),
    );

    final body = jsonDecode(response.body);
    if (_isSuccess(response.statusCode)) {
      return body['message']?.toString() ?? 'Order cancelled successfully';
    }

    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    return {
      ConstantKeys.appAuthorization: '${ConstantKeys.appBearer} $token',
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
    };
  }

  bool _isSuccess(int statusCode) {
    return statusCode == StatusCode.ok || statusCode == StatusCode.created;
  }
}
