class CheckoutCalculationResponseModel {
  final List<CheckoutItem> items;
  final int itemsCount;
  final Pricing pricing;
  final Coupon? coupon;
  final int addressId;

  CheckoutCalculationResponseModel({
    required this.items,
    required this.itemsCount,
    required this.pricing,
    this.coupon,
    required this.addressId,
  });

  factory CheckoutCalculationResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckoutCalculationResponseModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CheckoutItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      itemsCount: json['items_count'] ?? 0,
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
      coupon: json['coupon'] != null
          ? Coupon.fromJson(json['coupon'] as Map<String, dynamic>)
          : null,
      addressId: json['address_id'] ?? 0,
    );
  }
}

class CheckoutItem {
  final String id;
  final String productId;
  final String productName;
  final String? variantId;
  final String? variantName;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String? image;

  CheckoutItem({
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

  factory CheckoutItem.fromJson(Map<String, dynamic> json) {
    return CheckoutItem(
      id: json['id'] ?? "",
      productId: json['product_id'] ?? "",
      productName: json['product_name'] ?? "",
      variantId: json['variant_id'],
      variantName: json['variant_name'],
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      image: json['image'],
    );
  }
}

class Pricing {
  final double subtotal;
  final double discountAmount;
  final double taxRate;
  final String taxRatePercentage;
  final double taxAmount;
  final double shippingRate;
  final double total;

  Pricing({
    required this.subtotal,
    required this.discountAmount,
    required this.taxRate,
    required this.taxRatePercentage,
    required this.taxAmount,
    required this.shippingRate,
    required this.total,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      taxRate: (json['tax_rate'] as num?)?.toDouble() ?? 0.0,
      taxRatePercentage: json['tax_rate_percentage'] ?? "0%",
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      shippingRate: (json['shipping_rate'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Coupon {
  final String id;
  final String code;
  final double discount;

  Coupon({
    required this.id,
    required this.code,
    required this.discount,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] ?? "",
      code: json['code'] ?? "",
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

