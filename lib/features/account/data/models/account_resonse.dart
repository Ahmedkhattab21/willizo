class AccountResponseModel {
  final String message;
  final AccountData data;

  AccountResponseModel({required this.message, required this.data});

  factory AccountResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AccountResponseModel(
      message: json['message']?.toString() ?? '',
      data: AccountData.fromJson(
        rawData is Map<String, dynamic> ? rawData : <String, dynamic>{},
      ),
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

  static String _toString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      id: _toString(json['id']),
      email: _toString(json['email']),
      name: _toString(json['name']),
      phoneNumber: _toString(json['phone_number']),
      dateOfBirth: _toString(json['date_of_birth']),
      onboarding: Onboarding.fromJson(json['onboarding'] ?? {}),
    );
  }

  String get formattedDateOfBirth {
    if (dateOfBirth.isEmpty) return '';
    final parsedDate = DateTime.tryParse(dateOfBirth);
    if (parsedDate != null) {
      return parsedDate.toIso8601String().split('T').first;
    }
    return dateOfBirth.split('T').first;
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

  /// Parses JSON number (int or double) to int. API may return either type.
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    return 0;
  }

  factory Onboarding.fromJson(Map<String, dynamic> json) {
    return Onboarding(
      step: _toInt(json['step']),
      isCompleted: json['is_completed'] == true,
      progressPercentage: _toInt(json['progress_percentage']),
    );
  }
}
