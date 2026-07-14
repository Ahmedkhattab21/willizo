import 'package:intl/intl.dart';
import 'package:willizo/core/api/end_points.dart';

class OrdersResponseModel {
  final List<OrderData> data;

  const OrdersResponseModel({required this.data});

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return OrdersResponseModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(OrderData.fromJson)
              .toList() ??
          [],
    );
  }
}

class OrderDetailsResponseModel {
  final OrderData data;

  const OrderDetailsResponseModel({required this.data});

  factory OrderDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponseModel(
      data: OrderData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class OrderData {
  final String id;
  final String orderNumber;
  final String status;
  final List<OrderItemData> items;
  final ShippingAddressData? shippingAddress;
  final double subtotal;
  final double taxRate;
  final double taxAmount;
  final double shippingRate;
  final double discountAmount;
  final double total;
  final String? couponCode;
  final String? trackingNumber;
  final String? notes;
  final bool canBeCancelled;
  final String createdAt;
  final String updatedAt;

  const OrderData({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.items,
    this.shippingAddress,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.shippingRate,
    required this.discountAmount,
    required this.total,
    this.couponCode,
    this.trackingNumber,
    this.notes,
    required this.canBeCancelled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(OrderItemData.fromJson)
              .toList() ??
          [],
      shippingAddress: json['shipping_address'] is Map<String, dynamic>
          ? ShippingAddressData.fromJson(json['shipping_address'])
          : null,
      subtotal: _toDouble(json['subtotal']),
      taxRate: _toDouble(json['tax_rate']),
      taxAmount: _toDouble(json['tax_amount']),
      shippingRate: _toDouble(json['shipping_rate']),
      discountAmount: _toDouble(json['discount_amount']),
      total: _toDouble(json['total']),
      couponCode: json['coupon_code']?.toString(),
      trackingNumber: json['shipping_tracking_number']?.toString(),
      notes: json['notes']?.toString(),
      canBeCancelled: _toBool(json['can_be_cancelled']),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get displayNumber {
    if (orderNumber.isNotEmpty) return orderNumber;
    final endIndex = id.length < 8 ? id.length : 8;
    return id.substring(0, endIndex);
  }

  String get displayDate => _formatDate(createdAt);

  String get displayTotal => '\$${total.toStringAsFixed(2)}';

  String get statusLabel {
    final normalized = status.toLowerCase();
    if (normalized == 'delivered' || normalized == 'completed') {
      return 'Delivered';
    }
    if (normalized == 'cancelled' || normalized == 'canceled') {
      return 'Cancelled';
    }
    return 'Processing';
  }

  String get paymentStatusLabel {
    final normalized = status.toLowerCase();
    if (normalized == 'pending') return 'Pending';
    if (normalized == 'cancelled' || normalized == 'canceled') {
      return 'Cancelled';
    }
    return 'Paid';
  }
}

class OrderItemData {
  final String id;
  final OrderProductData? product;
  final String? variantId;
  final String productName;
  final String productSku;
  final String? variantSku;
  final int quantity;
  final double price;
  final double subtotal;
  final String createdAt;

  const OrderItemData({
    required this.id,
    this.product,
    this.variantId,
    required this.productName,
    required this.productSku,
    this.variantSku,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.createdAt,
  });

  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    return OrderItemData(
      id: json['id']?.toString() ?? '',
      product: json['product'] is Map<String, dynamic>
          ? OrderProductData.fromJson(json['product'])
          : null,
      variantId: json['variant_id']?.toString(),
      productName: json['product_name']?.toString() ?? '',
      productSku: json['product_sku']?.toString() ?? '',
      variantSku: json['variant_sku']?.toString(),
      quantity: _toInt(json['quantity']),
      price: _toDouble(json['price']),
      subtotal: _toDouble(json['subtotal']),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  String get displayName {
    final productNameValue = product?.name ?? '';
    return productNameValue.isNotEmpty ? productNameValue : productName;
  }

  String get productId => product?.id ?? '';

  String get displayPrice => '\$${price.toStringAsFixed(2)}';

  String get displayImage => product?.displayImage ?? '';
}

class OrderProductData {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String sku;
  final String? material;
  final List<String> images;

  const OrderProductData({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.sku,
    this.material,
    required this.images,
  });

  factory OrderProductData.fromJson(Map<String, dynamic> json) {
    return OrderProductData(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      material: json['material']?.toString(),
      images: _parseImages(json['images']),
    );
  }

  String get displayImage => images.isNotEmpty ? images.first : '';
}

class ShippingAddressData {
  final String fullAddress;
  final String country;
  final String city;
  final String street;
  final String building;
  final String floorApartment;
  final String district;
  final String governorate;
  final String phone;

  const ShippingAddressData({
    required this.fullAddress,
    required this.country,
    required this.city,
    required this.street,
    required this.building,
    required this.floorApartment,
    required this.district,
    required this.governorate,
    required this.phone,
  });

  factory ShippingAddressData.fromJson(Map<String, dynamic> json) {
    return ShippingAddressData(
      fullAddress: json['full_address']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      building: json['building']?.toString() ?? '',
      floorApartment: json['floor_apartment']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      governorate: json['governorate']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }

  List<String> get displayLines {
    if (fullAddress.isNotEmpty) {
      return [fullAddress, phone].where((e) => e.isNotEmpty).toList();
    }
    return [
      building,
      street,
      floorApartment,
      district,
      governorate,
      city,
      country,
      phone,
    ].where((line) => line.isNotEmpty).toList();
  }
}

List<String> _parseImages(dynamic value) {
  if (value is! List) return [];
  return value
      .map((image) {
        if (image is Map<String, dynamic>) {
          final fullUrl =
              image['full_url'] ??
              image['url'] ??
              image['image_url'] ??
              image['src'];
          if (fullUrl != null) return _imageUrl(fullUrl);
          final imagePath = image['image_path'] ?? image['path'];
          if (imagePath != null && imagePath.toString().isNotEmpty) {
            return 'https://willizo.com/storage/${imagePath.toString()}';
          }
          return _imageUrl(image['image']);
        }
        return _imageUrl(image);
      })
      .whereType<String>()
      .where((image) => image.isNotEmpty)
      .toList();
}

String? _imageUrl(dynamic value) {
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

String _formatDate(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  return DateFormat('MMM d, yyyy').format(date);
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}

bool _toBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.toLowerCase().trim();
    return normalized == 'true' || normalized == '1';
  }
  return false;
}
