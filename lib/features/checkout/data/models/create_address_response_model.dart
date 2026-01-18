import 'package:willizo/features/checkout/data/models/address_model.dart';

class CreateAddressResponseModel {
  final String message;
  final AddressModel address;

  CreateAddressResponseModel({
    required this.message,
    required this.address,
  });

  factory CreateAddressResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateAddressResponseModel(
      message: json['message'] ?? '',
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'address': address.toJson(),
    };
  }
}
