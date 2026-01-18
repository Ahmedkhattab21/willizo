class CheckoutCalculationRequestModel {
  final String addressId;
  final String? couponCode;

  CheckoutCalculationRequestModel({required this.addressId, this.couponCode});

  Map<String, dynamic> toJson() {
    final json = {'address_id': addressId};
    if (couponCode != null && couponCode!.isNotEmpty) {
      json['coupon_code'] = couponCode!;
    }
    return json;
  }
}
