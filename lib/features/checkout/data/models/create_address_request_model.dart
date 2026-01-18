class CreateAddressRequestModel {
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

  CreateAddressRequestModel({
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
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'country': country,
      'street': street,
      if (building != null && building!.isNotEmpty) 'building': building,
      if (floorApartment != null && floorApartment!.isNotEmpty)
        'floor_apartment': floorApartment,
      if (landmark != null && landmark!.isNotEmpty) 'landmark': landmark,
      'city': city,
      if (area != null && area!.isNotEmpty) 'area': area,
      if (district != null && district!.isNotEmpty) 'district': district,
      if (governorate != null && governorate!.isNotEmpty)
        'governorate': governorate,
      'phone': phone,
      'is_default': isDefault,
    };
  }
}
