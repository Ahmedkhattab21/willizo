class BodyPartsResponseModel {
  final List<BodyPartModel> data;

  const BodyPartsResponseModel({required this.data});

  factory BodyPartsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataRaw = json['data'];
    return BodyPartsResponseModel(
      data: dataRaw is List
          ? dataRaw
                .map(
                  (e) => BodyPartModel.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class BodyPartModel {
  final String id;
  final String slug;
  final String name;
  final String type;
  final String icon;
  final int exerciseCount;
  final List<BodyPartChildModel> children;

  const BodyPartModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.type,
    required this.icon,
    required this.exerciseCount,
    required this.children,
  });

  factory BodyPartModel.fromJson(Map<String, dynamic> json) {
    final childrenRaw = json['children'];
    return BodyPartModel(
      id: _toString(json['id']),
      slug: _toString(json['slug']),
      name: _toString(json['name']),
      type: _toString(json['type']),
      icon: _toString(json['icon']),
      exerciseCount: _toInt(json['exercise_count']),
      children: childrenRaw is List
          ? childrenRaw
                .map(
                  (e) => BodyPartChildModel.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class BodyPartChildModel {
  final String id;
  final String slug;
  final String name;
  final String type;
  final String icon;
  final int exerciseCount;

  const BodyPartChildModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.type,
    required this.icon,
    required this.exerciseCount,
  });

  factory BodyPartChildModel.fromJson(Map<String, dynamic> json) {
    return BodyPartChildModel(
      id: _toString(json['id']),
      slug: _toString(json['slug']),
      name: _toString(json['name']),
      type: _toString(json['type']),
      icon: _toString(json['icon']),
      exerciseCount: _toInt(json['exercise_count']),
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
