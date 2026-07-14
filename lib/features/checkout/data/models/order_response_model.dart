import 'package:willizo/features/checkout/data/models/address_model.dart';

class OrderResponseModel {
  final String message;
  final OrderModel order;
  final String checkoutUrl;
  final bool paymentRequired;

  OrderResponseModel({
    required this.message,
    required this.order,
    required this.checkoutUrl,
    required this.paymentRequired,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      message: json['message'] ?? '',
      order: OrderModel.fromJson(json['order'] ?? {}),
      checkoutUrl: json['checkout_url']?.toString() ?? '',
      paymentRequired: _toBool(json['payment_required']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'order': order.toJson(),
      'checkout_url': checkoutUrl,
      'payment_required': paymentRequired,
    };
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

class OrderModel {
  final String id;
  final String orderNumber;
  final String status;
  final List<OrderItemModel> items;
  final AddressModel shippingAddress;
  final double subtotal;
  final double taxRate;
  final double taxAmount;
  final double shippingRate;
  final double discountAmount;
  final double total;
  final String? couponCode;
  final String? shippingTrackingNumber;
  final String? notes;
  final bool canBeCancelled;
  final String createdAt;
  final String updatedAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.items,
    required this.shippingAddress,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.shippingRate,
    required this.discountAmount,
    required this.total,
    this.couponCode,
    this.shippingTrackingNumber,
    this.notes,
    required this.canBeCancelled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['order_number'] ?? '',
      status: json['status'] ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (item) => OrderItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      shippingAddress: AddressModel.fromJson(json['shipping_address'] ?? {}),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxRate: (json['tax_rate'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      shippingRate: (json['shipping_rate'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      couponCode: json['coupon_code'],
      shippingTrackingNumber: json['shipping_tracking_number'],
      notes: json['notes'],
      canBeCancelled: json['can_be_cancelled'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status,
      'items': items.map((item) => item.toJson()).toList(),
      'shipping_address': shippingAddress.toJson(),
      'subtotal': subtotal,
      'tax_rate': taxRate,
      'tax_amount': taxAmount,
      'shipping_rate': shippingRate,
      'discount_amount': discountAmount,
      'total': total,
      'coupon_code': couponCode,
      'shipping_tracking_number': shippingTrackingNumber,
      'notes': notes,
      'can_be_cancelled': canBeCancelled,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class OrderItemModel {
  final String id;
  final OrderProductModel? product;
  final OrderVariantModel? variant;
  final String? variantId;
  final String productName;
  final String productSku;
  final String? variantSku;
  final int quantity;
  final double price;
  final double subtotal;
  final String createdAt;

  OrderItemModel({
    required this.id,
    this.product,
    this.variant,
    this.variantId,
    required this.productName,
    required this.productSku,
    this.variantSku,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.createdAt,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      product: json['product'] != null
          ? OrderProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      variant: json['variant'] != null
          ? OrderVariantModel.fromJson(json['variant'] as Map<String, dynamic>)
          : null,
      variantId: json['variant_id'],
      productName: json['product_name'] ?? '',
      productSku: json['product_sku'] ?? '',
      variantSku: json['variant_sku'],
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product?.toJson(),
      'variant': variant?.toJson(),
      'variant_id': variantId,
      'product_name': productName,
      'product_sku': productSku,
      'variant_sku': variantSku,
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal,
      'created_at': createdAt,
    };
  }
}

class OrderProductModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String? comparePrice;
  final String sku;
  final String? material;
  final double averageRating;
  final int reviewCount;
  final String createdAt;
  final String updatedAt;

  OrderProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    this.comparePrice,
    required this.sku,
    this.material,
    required this.averageRating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      comparePrice: json['compare_price'],
      sku: json['sku'] ?? '',
      material: json['material'],
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'compare_price': comparePrice,
      'sku': sku,
      'material': material,
      'average_rating': averageRating,
      'review_count': reviewCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class OrderVariantModel {
  final String id;
  final String sku;
  final int stockQuantity;
  final double additionalPrice;
  final bool isAvailable;

  OrderVariantModel({
    required this.id,
    required this.sku,
    required this.stockQuantity,
    required this.additionalPrice,
    required this.isAvailable,
  });

  factory OrderVariantModel.fromJson(Map<String, dynamic> json) {
    return OrderVariantModel(
      id: json['id'] ?? '',
      sku: json['sku'] ?? '',
      stockQuantity: json['stock_quantity'] ?? 0,
      additionalPrice: (json['additional_price'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['is_available'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'stock_quantity': stockQuantity,
      'additional_price': additionalPrice,
      'is_available': isAvailable,
    };
  }
}
