class AccountResponseModel {
  final bool status;
  final String message;
  final AccountData? data;

  AccountResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory AccountResponseModel.fromJson(Map<String, dynamic> json) {
    return AccountResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AccountData.fromJson(json['data']) : null,
    );
  }
}

class AccountData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String image;
  final String createdAt;

  AccountData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.createdAt,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "image": image,
      "created_at": createdAt,
    };
  }
}
