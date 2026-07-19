class BannerModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? linkUrl;
  final int sortOrder;
  final bool isActive;

  const BannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.linkUrl,
    required this.sortOrder,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      linkUrl: json['link_url']?.toString(),
      sortOrder: _toInt(json['sort_order']),
      isActive: _toBool(json['is_active']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value?.toString().toLowerCase().trim();
    return normalized == 'true' || normalized == '1';
  }
}
