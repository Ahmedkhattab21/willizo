import 'package:willizo/core/api/end_points.dart';

class ShopResponseModel {
  final List<Product> data;

  ShopResponseModel({required this.data});

  factory ShopResponseModel.fromJson(Map<String, dynamic> json) {
    return ShopResponseModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Product {
  final String id;
  final Category category;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String? comparePrice;
  final String sku;
  final String? barcode;
  final String weight;
  final int stockQuantity;
  final String stockStatus;
  final String status;
  final List<String> images;
  final String? primaryImage;
  final bool isAvailable;
  final bool isInWishlist;
  final bool isInCart;
  final double averageRating;
  final int reviewCount;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.category,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    this.comparePrice,
    required this.sku,
    this.barcode,
    required this.weight,
    required this.stockQuantity,
    required this.stockStatus,
    required this.status,
    required this.images,
    this.primaryImage,
    required this.isAvailable,
    required this.isInWishlist,
    required this.isInCart,
    required this.averageRating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? "",
      category: Category.fromJson(json['category'] ?? {}),
      name: json['name'] ?? "",
      slug: json['slug'] ?? "",
      description: json['description'] ?? "",
      price: json['price']?.toString() ?? "",
      comparePrice: json['compare_price']?.toString(),
      sku: json['sku'] ?? "",
      barcode: json['barcode'],
      weight: json['weight']?.toString() ?? "",
      stockQuantity: _toInt(json['stock_quantity']),
      stockStatus: json['stock_status'] ?? "",
      status: json['status'] ?? "",
      images: _parseImages(json['images']),
      primaryImage: json['primary_image'] is Map<String, dynamic>
          ? _imageFromMap(json['primary_image'])
          : _imageUrl(json['primary_image']),
      isAvailable: _toBool(json['is_available']),
      isInWishlist: _toBool(json['is_in_wishlist']),
      isInCart: _toBool(json['is_in_cart']),
      averageRating: _toDouble(json['average_rating']),
      reviewCount: _toInt(json['review_count']),
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  String get displayImage {
    if (primaryImage != null && primaryImage!.isNotEmpty) return primaryImage!;
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

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalizedValue = value.toLowerCase().trim();
      return normalizedValue == 'true' || normalizedValue == '1';
    }
    return false;
  }
}

class Category {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? image;
  final String status;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      slug: json['slug'] ?? "",
      description: json['description'] ?? "",
      image: json['image'],
      status: json['status'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}
