import 'package:willizo/core/api/end_points.dart';

class GymEquipmentsResponse {
  final bool success;
  final GymData? data;

  GymEquipmentsResponse({required this.success, this.data});

  factory GymEquipmentsResponse.fromJson(Map<String, dynamic> json) {
    return GymEquipmentsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? GymData.fromJson(json['data']) : null,
    );
  }
}

class GymData {
  final String category;
  final int total;
  final List<Equipment> equipments;

  GymData({
    required this.category,
    required this.total,
    required this.equipments,
  });

  factory GymData.fromJson(Map<String, dynamic> json) {
    return GymData(
      category: json['category'] ?? '',
      total: json['total'] ?? 0,
      equipments:
          (json['equipments'] as List<dynamic>?)
              ?.map((e) => Equipment.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Equipment {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  Equipment({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] != null 
          ? EndPoints.getImageFromApi(json['image'])
          : '',
    );
  }
}
