import 'package:willizo/features/shop/data/models/shop_model_response.dart';

class WishlistResponseModel {
  final List<WishlistItem> data;

  WishlistResponseModel({required this.data});

  factory WishlistResponseModel.fromJson(Map<String, dynamic> json) {
    return WishlistResponseModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => WishlistItem.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class WishlistItem {
  final String id;
  final Product product;
  final String addedAt;

  WishlistItem({
    required this.id,
    required this.product,
    required this.addedAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] ?? "",
      product: Product.fromJson(json['product'] ?? {}),
      addedAt: json['added_at'] ?? "",
    );
  }
}
