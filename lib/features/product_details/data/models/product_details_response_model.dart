import 'package:willizo/core/api/end_points.dart';

class ProductDetailsResponseModel {
  final ProductData? data;

  ProductDetailsResponseModel({this.data});

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponseModel(
      data: json['data'] != null ? ProductData.fromJson(json['data']) : null,
    );
  }
}

class ProductData {
  final String id;
  final Category category;
  final String name;
  final String slug;
  final String description;
  final List<String> keyFeatures;
  final Map<String, String> specifications;
  final String price;
  final String? comparePrice;
  final String sku;
  final ProductDimensions? dimensions;
  final int stockQuantity;
  final String stockStatus;
  final String status;
  final List<String> images;
  final String? primaryImage;
  final bool isAvailable;
  final List<ProductOption> options;
  final List<ProductVariant> variants;
  final bool isInWishlist;
  final bool isInCart;
  final DeliveryInfo? deliveryInfo;
  final ReturnInfo? returnInfo;
  final String? warranty;
  final String material;
  final num averageRating;
  final int reviewCount;
  final String createdAt;
  final String updatedAt;

  ProductData({
    required this.id,
    required this.category,
    required this.name,
    required this.slug,
    required this.description,
    required this.keyFeatures,
    required this.specifications,
    required this.price,
    this.comparePrice,
    required this.sku,
    this.dimensions,
    required this.stockQuantity,
    required this.stockStatus,
    required this.status,
    required this.images,
    this.primaryImage,
    required this.isAvailable,
    required this.options,
    required this.variants,
    required this.isInWishlist,
    required this.isInCart,
    this.deliveryInfo,
    this.returnInfo,
    this.warranty,
    required this.material,
    required this.averageRating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      keyFeatures:
          (json['key_features'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      specifications: _toStringMap(json['specifications']),
      price: json['price']?.toString() ?? '',
      comparePrice: json['compare_price']?.toString(),
      sku: json['sku'] ?? '',
      dimensions: json['dimensions'] is Map<String, dynamic>
          ? ProductDimensions.fromJson(json['dimensions'])
          : null,
      stockQuantity: _toInt(json['stock_quantity']),
      stockStatus: json['stock_status'] ?? '',
      status: json['status'] ?? '',
      images: _parseImages(json['images']),
      primaryImage: json['primary_image'] is Map<String, dynamic>
          ? _imageFromMap(json['primary_image'])
          : _imageUrl(json['primary_image']),
      isAvailable: json['is_available'] ?? false,
      options:
          (json['options'] as List?)
              ?.map((e) => ProductOption.fromJson(e))
              .toList() ??
          [],
      variants:
          (json['variants'] as List?)
              ?.map((e) => ProductVariant.fromJson(e))
              .toList() ??
          [],
      isInWishlist: _toBool(json['is_in_wishlist']),
      isInCart: _toBool(json['is_in_cart']),
      deliveryInfo: json['delivery_info'] is Map<String, dynamic>
          ? DeliveryInfo.fromJson(json['delivery_info'])
          : null,
      returnInfo: json['return_info'] is Map<String, dynamic>
          ? ReturnInfo.fromJson(json['return_info'])
          : null,
      warranty: json['warranty']?.toString(),
      material: json['material']?.toString() ?? '',
      averageRating: _toNum(json['average_rating']),
      reviewCount: _toInt(json['review_count']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
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

  static Map<String, String> _toStringMap(dynamic value) {
    if (value is! Map) return {};
    return value.map(
      (key, mapValue) => MapEntry(key.toString(), mapValue?.toString() ?? ''),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static num _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
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

class ProductDimensions {
  final String length;
  final String width;
  final String height;
  final String weight;

  ProductDimensions({
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
  });

  factory ProductDimensions.fromJson(Map<String, dynamic> json) {
    return ProductDimensions(
      length: json['length']?.toString() ?? '',
      width: json['width']?.toString() ?? '',
      height: json['height']?.toString() ?? '',
      weight: json['weight']?.toString() ?? '',
    );
  }

  Map<String, String> toDisplayMap() {
    return {
      if (length.isNotEmpty) 'Length': length,
      if (width.isNotEmpty) 'Width': width,
      if (height.isNotEmpty) 'Height': height,
      if (weight.isNotEmpty) 'Weight': weight,
    };
  }
}

class DeliveryInfo {
  final bool freeDelivery;
  final String deliveryTime;

  DeliveryInfo({required this.freeDelivery, required this.deliveryTime});

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) {
    return DeliveryInfo(
      freeDelivery: json['free_delivery'] ?? false,
      deliveryTime: json['delivery_time']?.toString() ?? '',
    );
  }
}

class ReturnInfo {
  final bool returnable;
  final String returnTime;

  ReturnInfo({required this.returnable, required this.returnTime});

  factory ReturnInfo.fromJson(Map<String, dynamic> json) {
    return ReturnInfo(
      returnable: json['returnable'] ?? false,
      returnTime: json['return_time']?.toString() ?? '',
    );
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class ProductOption {
  final String id;
  final String name;
  final int displayOrder;
  final List<OptionValue> values;

  ProductOption({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.values,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      displayOrder: ProductData._toInt(json['display_order']),
      values:
          (json['values'] as List?)
              ?.map((e) => OptionValue.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OptionValue {
  final String id;
  final String value;
  final String? hexColor;
  final int displayOrder;

  OptionValue({
    required this.id,
    required this.value,
    this.hexColor,
    required this.displayOrder,
  });

  factory OptionValue.fromJson(Map<String, dynamic> json) {
    return OptionValue(
      id: json['id'] ?? '',
      value: json['value'] ?? '',
      hexColor: json['hex_color'],
      displayOrder: ProductData._toInt(json['display_order']),
    );
  }
}

class ProductVariant {
  final String id;
  final String sku;
  final int stockQuantity;
  final String additionalPrice;
  final bool isAvailable;
  final List<String> optionValues;
  final String optionCombination;

  ProductVariant({
    required this.id,
    required this.sku,
    required this.stockQuantity,
    required this.additionalPrice,
    required this.isAvailable,
    required this.optionValues,
    required this.optionCombination,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] ?? '',
      sku: json['sku'] ?? '',
      stockQuantity: ProductData._toInt(json['stock_quantity']),
      additionalPrice: json['additional_price']?.toString() ?? '0',
      isAvailable: json['is_available'] ?? false,
      optionValues:
          (json['option_values'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      optionCombination: json['option_combination'] ?? '',
    );
  }
}
