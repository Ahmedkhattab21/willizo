class AddProductToCartRequest {
  final String productId;
  final int quantity;
  final String? variantId;

  AddProductToCartRequest({
    required this.productId,
    required this.quantity,
    this.variantId,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      if (variantId != null) 'variant_id': variantId,
    };
  }
}
