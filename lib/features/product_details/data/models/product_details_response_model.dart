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
  final String price;
  final String? comparePrice;
  final String sku;
  final String weight;
  final int stockQuantity;
  final String stockStatus;
  final String status;
  final List<dynamic> images;
  final String? primaryImage;
  final bool isAvailable;
  final List<ProductOption> options;
  final List<ProductVariant> variants;
  final bool isInWishlist;
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
    required this.price,
    this.comparePrice,
    required this.sku,
    required this.weight,
    required this.stockQuantity,
    required this.stockStatus,
    required this.status,
    required this.images,
    this.primaryImage,
    required this.isAvailable,
    required this.options,
    required this.variants,
    required this.isInWishlist,
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
      price: json['price'] ?? '',
      comparePrice: json['compare_price'],
      sku: json['sku'] ?? '',
      weight: json['weight'] ?? '',
      stockQuantity: json['stock_quantity'] ?? 0,
      stockStatus: json['stock_status'] ?? '',
      status: json['status'] ?? '',
      images: json['images'] ?? [],
      primaryImage: json['primary_image'],
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
      isInWishlist: json['is_in_wishlist'] ?? false,
      averageRating: json['average_rating'] ?? 0,
      reviewCount: json['review_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
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
      displayOrder: json['display_order'] ?? 0,
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
      displayOrder: json['display_order'] ?? 0,
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
      stockQuantity: json['stock_quantity'] ?? 0,
      additionalPrice: json['additional_price']?.toString() ?? '0',
      isAvailable: json['is_available'] ?? false,
      optionValues:
          (json['option_values'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      optionCombination: json['option_combination'] ?? '',
    );
  }
}
