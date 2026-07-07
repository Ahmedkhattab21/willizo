import 'package:willizo/core/api/end_points.dart';

class FreeWeightsResponse {
  final bool success;
  final FreeWeightsData? data;

  FreeWeightsResponse({required this.success, this.data});

  factory FreeWeightsResponse.fromJson(Map<String, dynamic> json) {
    return FreeWeightsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? FreeWeightsData.fromJson(json['data'])
          : null,
    );
  }
}

class FreeWeightsData {
  final String category;
  final int total;
  final List<Equipment> equipments;

  FreeWeightsData({
    required this.category,
    required this.total,
    required this.equipments,
  });

  factory FreeWeightsData.fromJson(Map<String, dynamic> json) {
    return FreeWeightsData(
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
    if (value is String) {
      final trimmedValue = value.trim();
      return int.tryParse(trimmedValue) ??
          num.tryParse(trimmedValue)?.toInt() ??
          0;
    }
    return 0;
  }
}

class Equipment {
  final String id;
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
      id: _toId(
        json['id'] ??
            json['equipment_id'] ??
            json['free_weight_id'] ??
            json['weight_id'],
      ),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] != null
          ? EndPoints.getImageFromApi(json['image'])
          : '',
    );
  }

  String get selectionKey {
    if (id.isNotEmpty) return 'id:$id';
    return 'fallback:$name|$imageUrl|$description';
  }

  static String _toId(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }
}
