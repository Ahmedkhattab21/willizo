class CreateLeagueRequestModel {
  final String name;
  final String description;
  final String type;
  final String privacy;
  final int? maxMembers;

  CreateLeagueRequestModel({
    required this.name,
    required this.description,
    required this.type,
    required this.privacy,
    this.maxMembers,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
        'privacy': privacy,
        if (maxMembers != null) 'max_members': maxMembers,
      };
}
