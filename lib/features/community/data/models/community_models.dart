class CommunityResponseModel {
  final bool status;
  final String message;
  final List<CommunityData> data;

  CommunityResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CommunityResponseModel.fromJson(Map<String, dynamic> json) {
    return CommunityResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => CommunityData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CommunityData {
  final int id;
  final String name;
  final String description;
  final String image;
  final int membersCount;
  final String createdAt;

  CommunityData({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.membersCount,
    required this.createdAt,
  });

  factory CommunityData.fromJson(Map<String, dynamic> json) {
    return CommunityData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      membersCount: json['members_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "image": image,
      "members_count": membersCount,
      "created_at": createdAt,
    };
  }
}
