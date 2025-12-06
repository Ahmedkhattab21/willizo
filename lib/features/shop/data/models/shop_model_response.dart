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
  final List<dynamic> images;
  final bool isAvailable;
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
    required this.isAvailable,
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
      price: json['price'] ?? "",
      comparePrice: json['compare_price'],
      sku: json['sku'] ?? "",
      barcode: json['barcode'],
      weight: json['weight'] ?? "",
      stockQuantity: json['stock_quantity'] ?? 0,
      stockStatus: json['stock_status'] ?? "",
      status: json['status'] ?? "",
      images: json['images'] ?? [],
      isAvailable: json['is_available'] ?? false,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
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
