class ShopResponseModel {
  final bool status;
  final String message;
  final ShopData? data;

  ShopResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory ShopResponseModel.fromJson(Map<String, dynamic> json) {
    return ShopResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ShopData.fromJson(json['data']) : null,
    );
  }
}

class ShopData {
  final List<CategoryData> categories;
  final List<ProductData> products;

  ShopData({
    required this.categories,
    required this.products,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      categories: (json['categories'] as List<dynamic>?)
              ?.map((item) => CategoryData.fromJson(item))
              .toList() ??
          [],
      products: (json['products'] as List<dynamic>?)
              ?.map((item) => ProductData.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "categories": categories.map((c) => c.toJson()).toList(),
      "products": products.map((p) => p.toJson()).toList(),
    };
  }
}

class CategoryData {
  final int id;
  final String name;
  final String image;

  CategoryData({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
    };
  }
}

class ProductData {
  final int id;
  final String name;
  final String description;
  final double price;
  final double oldPrice;
  final int discount;
  final String image;
  final bool inFavorites;
  final bool inCart;

  ProductData({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.image,
    required this.inFavorites,
    required this.inCart,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: (json['old_price'] ?? 0).toDouble(),
      discount: json['discount'] ?? 0,
      image: json['image'] ?? '',
      inFavorites: json['in_favorites'] ?? false,
      inCart: json['in_cart'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "old_price": oldPrice,
      "discount": discount,
      "image": image,
      "in_favorites": inFavorites,
      "in_cart": inCart,
    };
  }
}
