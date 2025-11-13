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
