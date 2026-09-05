class BodyPartExercisesResponseModel {
  final List<BodyPartExerciseModel> data;

  const BodyPartExercisesResponseModel({required this.data});

  factory BodyPartExercisesResponseModel.fromJson(Map<String, dynamic> json) {
    final dataRaw = json['data'];
    return BodyPartExercisesResponseModel(
      data: dataRaw is List
          ? dataRaw
                .map(
                  (e) => BodyPartExerciseModel.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class BodyPartExerciseModel {
  final String id;
  final String name;
  final String slug;
  final String icon;
  final String description;
  final String category;
  final String unit;
  final bool isActive;
  final int sortOrder;

  const BodyPartExerciseModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.description,
    required this.category,
    required this.unit,
    required this.isActive,
    required this.sortOrder,
  });

  factory BodyPartExerciseModel.fromJson(Map<String, dynamic> json) {
    return BodyPartExerciseModel(
      id: _toString(json['id']),
      name: _toString(json['name']),
      slug: _toString(json['slug']),
      icon: _toString(json['icon']),
      description: _toString(json['description']),
      category: _toString(json['category']),
      unit: _toString(json['unit']),
      isActive: json['is_active'] == true,
      sortOrder: _toInt(json['sort_order']),
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is num) return value.toInt();
  return 0;
}

String _toString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}
