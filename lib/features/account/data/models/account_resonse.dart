class AccountResponseModel {
  final String message;
  final AccountData data;

  AccountResponseModel({
    required this.message,
    required this.data,
  });

  factory AccountResponseModel.fromJson(Map<String, dynamic> json) {
    return AccountResponseModel(
      message: json['message'] ?? "",
      data: AccountData.fromJson(json['data'] ?? {}),
    );
  }
}

class AccountData {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final String dateOfBirth;
  final Onboarding onboarding;

  AccountData({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.onboarding,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      id: json['id'] ?? "",
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      dateOfBirth: json['date_of_birth'] ?? "",
      onboarding: Onboarding.fromJson(json['onboarding'] ?? {}),
    );
  }
}

class Onboarding {
  final int step;
  final bool isCompleted;
  final int progressPercentage;

  Onboarding({
    required this.step,
    required this.isCompleted,
    required this.progressPercentage,
  });

  factory Onboarding.fromJson(Map<String, dynamic> json) {
    return Onboarding(
      step: json['step'] ?? 0,
      isCompleted: json['is_completed'] ?? false,
      progressPercentage: json['progress_percentage'] ?? 0,
    );
  }
}
