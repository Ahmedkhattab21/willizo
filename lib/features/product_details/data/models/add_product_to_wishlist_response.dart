import 'package:willizo/features/product_details/data/models/product_details_response_model.dart';

class AddProductToWishlistResponse {
  final String message;
  final WishlistData wishlist;

  AddProductToWishlistResponse({required this.message, required this.wishlist});

  factory AddProductToWishlistResponse.fromJson(Map<String, dynamic> json) {
    return AddProductToWishlistResponse(
      message: json['message'] ?? '',
      wishlist: WishlistData.fromJson(json['wishlist'] ?? {}),
    );
  }
}

class WishlistData {
  final String id;
  final ProductData product;
  final String addedAt;

  WishlistData({
    required this.id,
    required this.product,
    required this.addedAt,
  });

  factory WishlistData.fromJson(Map<String, dynamic> json) {
    return WishlistData(
      id: json['id'] ?? '',
      product: ProductData.fromJson(json['product'] ?? {}),
      addedAt: json['added_at'] ?? '',
    );
  }
}
