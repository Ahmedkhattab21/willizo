import 'package:willizo/features/cart/data/models/cart_response_model.dart';

class UpdateCartCountResponse {
  final String message;
  final CartData cart;

  UpdateCartCountResponse({required this.message, required this.cart});

  factory UpdateCartCountResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCartCountResponse(
      message: json['message'] ?? '',
      cart: CartData.fromJson(json['cart'] ?? {}),
    );
  }
}
