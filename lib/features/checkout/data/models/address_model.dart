class AddressModel {
  final String id;
  final String type;
  final String country;
  final String street;
  final String? building;
  final String? floorApartment;
  final String? landmark;
  final String city;
  final String? area;
  final String? district;
  final String? governorate;
  final String phone;
  final bool isDefault;
  final String fullAddress;
  final String createdAt;
  final String updatedAt;

  AddressModel({
    required this.id,
    required this.type,
    required this.country,
    required this.street,
    this.building,
    this.floorApartment,
    this.landmark,
    required this.city,
    this.area,
    this.district,
    this.governorate,
    required this.phone,
    required this.isDefault,
    required this.fullAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      country: json['country'] ?? '',
      street: json['street'] ?? '',
      building: json['building'],
      floorApartment: json['floor_apartment'],
      landmark: json['landmark'],
      city: json['city'] ?? '',
      area: json['area'],
      district: json['district'],
      governorate: json['governorate'],
      phone: json['phone'] ?? '',
      isDefault: json['is_default'] ?? false,
      fullAddress: json['full_address'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'country': country,
      'street': street,
      'building': building,
      'floor_apartment': floorApartment,
      'landmark': landmark,
      'city': city,
      'area': area,
      'district': district,
      'governorate': governorate,
      'phone': phone,
      'is_default': isDefault,
      'full_address': fullAddress,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class AddressResponseModel {
  final List<AddressModel> data;

  AddressResponseModel({required this.data});

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) {
    return AddressResponseModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => AddressModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.map((item) => item.toJson()).toList()};
  }
}
