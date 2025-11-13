import 'package:willizo/core/api/end_points.dart';

class SupportiveToolsResponse {
  final bool success;
  final SupportiveToolsData? data;

  SupportiveToolsResponse({required this.success, this.data});

  factory SupportiveToolsResponse.fromJson(Map<String, dynamic> json) {
    return SupportiveToolsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? SupportiveToolsData.fromJson(json['data'])
          : null,
    );
  }
}

class SupportiveToolsData {
  final String category;
  final int total;
  final List<Equipment> equipments;

  SupportiveToolsData({
    required this.category,
    required this.total,
    required this.equipments,
  });

  factory SupportiveToolsData.fromJson(Map<String, dynamic> json) {
    return SupportiveToolsData(
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
