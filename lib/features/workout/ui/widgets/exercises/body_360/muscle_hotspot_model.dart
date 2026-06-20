class MuscleHotspot {
  const MuscleHotspot({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final double x;
  final double y;
  final double w;
  final double h;

  factory MuscleHotspot.fromJson(Map<String, dynamic> json) {
    return MuscleHotspot(
      id: _toString(json['id']),
      nameAr: _toString(json['name_ar']),
      nameEn: _toString(json['name_en']),
      x: _toDouble(json['x']),
      y: _toDouble(json['y']),
      w: _toDouble(json['w']),
      h: _toDouble(json['h']),
    );
  }
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

String _toString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}
