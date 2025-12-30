import 'package:willizo/features/cart/data/models/cart_response_model.dart';

class DeleteCartItemResponse {
  final String message;
  final CartData cart;

  DeleteCartItemResponse({required this.message, required this.cart});

  factory DeleteCartItemResponse.fromJson(Map<String, dynamic> json) {
    return DeleteCartItemResponse(
      message: json['message'] ?? '',
      cart: CartData.fromJson(json['cart'] ?? {}),
    );
  }
}

