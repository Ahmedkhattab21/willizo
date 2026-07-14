import 'package:willizo/core/api/end_points.dart';

class CartResponseModel {
  final CartData data;

  CartResponseModel({required this.data});

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(data: CartData.fromJson(json['data'] ?? {}));
  }
}

class CartData {
  final String id;
  final List<CartItem> items;
  final int totalItems;
  final double subtotal;
  final String createdAt;
  final String updatedAt;

  CartData({
    required this.id,
    required this.items,
    required this.totalItems,
    required this.subtotal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'] ?? "",
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalItems: json['total_items'] ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}

class CartItem {
  final String id;
  final CartProduct product;
  final int quantity;
  final String price;
  final String subtotal;
  final String createdAt;
  final String updatedAt;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? "",
      product: CartProduct.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 0,
      price: parsePrice(json['price']),
      subtotal: parsePrice(json['subtotal']),
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}

class CartProduct {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String? comparePrice;
  final String sku;
  final String weight;
  final int stockQuantity;
  final String stockStatus;
  final String status;
  final List<String> images;
  final bool isAvailable;
  final bool isInWishlist;
  final double averageRating;
  final int reviewCount;
  final String createdAt;
  final String updatedAt;

  CartProduct({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    this.comparePrice,
    required this.sku,
    required this.weight,
    required this.stockQuantity,
    required this.stockStatus,
    required this.status,
    required this.images,
    required this.isAvailable,
    required this.isInWishlist,
    required this.averageRating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      slug: json['slug'] ?? "",
      description: json['description'] ?? "",
      price: parsePrice(json['price']),
      comparePrice: json['compare_price'] != null
          ? parsePrice(json['compare_price'])
          : null,
      sku: json['sku'] ?? "",
      weight: json['weight'] ?? "",
      stockQuantity: json['stock_quantity'] ?? 0,
      stockStatus: json['stock_status'] ?? "",
      status: json['status'] ?? "",
      images: _parseImages(json['images']),
      isAvailable: json['is_available'] ?? false,
      isInWishlist: json['is_in_wishlist'] ?? false,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  String get displayImage {
    if (images.isNotEmpty) return images.first;
    return "assets/images/banner_image.png";
  }

  static List<String> _parseImages(dynamic value) {
    if (value is! List) return [];
    return value
        .map((image) {
          if (image is Map<String, dynamic>) {
            return _imageFromMap(image);
          }
          return _imageUrl(image);
        })
        .whereType<String>()
        .where((image) => image.isNotEmpty)
        .toList();
  }

  static String? _imageUrl(dynamic value) {
    if (value == null) return null;
    final image = value.toString();
    if (image.isEmpty) return null;
    if (image.startsWith('http://') ||
        image.startsWith('https://') ||
        image.startsWith('assets/')) {
      return image;
    }
    return EndPoints.getImageFromApi(image);
  }

  static String? _imageFromMap(Map<String, dynamic> image) {
    final fullUrl =
        image['full_url'] ?? image['url'] ?? image['image_url'] ?? image['src'];
    if (fullUrl != null) return _imageUrl(fullUrl);

    final imagePath = image['image_path'] ?? image['path'];
    if (imagePath != null && imagePath.toString().isNotEmpty) {
      return 'https://willizo.com/storage/${imagePath.toString()}';
    }

    return _imageUrl(image['image']);
  }
}

String parsePrice(dynamic value) {
  if (value == null) return "0.00";
  if (value is num) return value.toStringAsFixed(2);
  if (value is String) return value;
  return "0.00";
}
