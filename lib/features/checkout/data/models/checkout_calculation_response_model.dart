class CheckoutCalculationResponseModel {
  final List<CheckoutItemModel> items;
  final int itemsCount;
  final CheckoutPricingModel pricing;
  final CheckoutCouponModel coupon;
  final String addressId;

  CheckoutCalculationResponseModel({
    required this.items,
    required this.itemsCount,
    required this.pricing,
    required this.coupon,
    required this.addressId,
  });

  factory CheckoutCalculationResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckoutCalculationResponseModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (item) =>
                    CheckoutItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      itemsCount: json['items_count'] ?? 0,
      pricing: CheckoutPricingModel.fromJson(
        json['pricing'] as Map<String, dynamic>? ?? {},
      ),
      coupon: CheckoutCouponModel.fromJson(
        json['coupon'] as Map<String, dynamic>? ?? {},
      ),
      addressId: json['address_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'items_count': itemsCount,
      'pricing': pricing.toJson(),
      'coupon': coupon.toJson(),
      'address_id': addressId,
    };
  }
}

class CheckoutItemModel {
  final String id;
  final String productId;
  final String productName;
  final String? variantId;
  final String? variantName;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String? image;

  CheckoutItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.variantId,
    this.variantName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.image,
  });

  factory CheckoutItemModel.fromJson(Map<String, dynamic> json) {
    return CheckoutItemModel(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      variantId: json['variant_id'],
      variantName: json['variant_name'],
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'variant_id': variantId,
      'variant_name': variantName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
      'image': image,
    };
  }
}

class CheckoutPricingModel {
  final double subtotal;
  final double discountAmount;
  final double taxRate;
  final String taxRatePercentage;
  final double taxAmount;
  final double shippingRate;
  final double total;

  CheckoutPricingModel({
    required this.subtotal,
    required this.discountAmount,
    required this.taxRate,
    required this.taxRatePercentage,
    required this.taxAmount,
    required this.shippingRate,
    required this.total,
  });

  factory CheckoutPricingModel.fromJson(Map<String, dynamic> json) {
    return CheckoutPricingModel(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      taxRate: (json['tax_rate'] as num?)?.toDouble() ?? 0.0,
      taxRatePercentage: json['tax_rate_percentage'] ?? '0%',
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      shippingRate: (json['shipping_rate'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_rate': taxRate,
      'tax_rate_percentage': taxRatePercentage,
      'tax_amount': taxAmount,
      'shipping_rate': shippingRate,
      'total': total,
    };
  }
}

class CheckoutCouponModel {
  final String? code;
  final bool valid;
  final String? message;

  CheckoutCouponModel({this.code, required this.valid, this.message});

  factory CheckoutCouponModel.fromJson(Map<String, dynamic> json) {
    return CheckoutCouponModel(
      code: json['code'],
      valid: json['valid'] ?? false,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'valid': valid, 'message': message};
  }
}
