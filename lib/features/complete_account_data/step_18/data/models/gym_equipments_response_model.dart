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
      total: _toInt(json['total']),
      equipments:
          (json['equipments'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => Equipment.fromJson(e))
              .toList() ??
          [],
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
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
      id: _toInt(
        json['id'] ??
            json['equipment_id'] ??
            json['gym_equipment_id'] ??
            json['machine_id'],
      ),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] != null
          ? EndPoints.getImageFromApi(json['image'])
          : '',
    );
  }

  String get selectionKey {
    if (id > 0) return 'id:$id';
    return 'fallback:$name|$imageUrl|$description';
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
