import 'package:willizo/core/api/end_points.dart';

class CartApiEndpoints {
  static const String cartUrl = '${EndPoints.baseUrl}/cart';
  static String updateCartItemQuantity(String cartItemId) =>
      '$cartUrl/items/$cartItemId';

  static String deleteAllCartItems = '${EndPoints.baseUrl}/cart/clear';
  static String deleteCartItem(String cartItemId) =>
      '$cartUrl/items/$cartItemId';
}
