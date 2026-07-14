import 'package:willizo/core/api/end_points.dart';

class OrdersApiEndpoints {
  static const String orders = '${EndPoints.baseUrl}/orders';

  static String orderDetails(String orderId) =>
      '${EndPoints.baseUrl}/orders/$orderId';
}
