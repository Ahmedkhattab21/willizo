class CreateLeagueResponseModel {
  final String id;
  final String name;
  final String type;
  final String scoringType;
  final String description;
  final String createdBy;
  final String createdAt;

  CreateLeagueResponseModel({
    required this.id,
    required this.name,
    required this.type,
    required this.scoringType,
    required this.description,
    required this.createdBy,
    required this.createdAt,
  });

  factory CreateLeagueResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateLeagueResponseModel(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        scoringType: json['scoring_type'] as String,
        description: json['description'] as String,
        createdBy: json['created_by'] as String,
        createdAt: json['created_at'] as String,
      );
}
