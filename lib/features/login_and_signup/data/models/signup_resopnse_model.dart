class SignupResponseModel {
  final bool success;
  final String message;
  final SignupData? data;

  SignupResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? SignupData.fromJson(json['data']) : null,
    );
  }
}

class SignupData {
  final User? user;
  final Tokens? tokens;
  final bool? emailVerificationSent;

  SignupData({
    this.user,
    this.tokens,
    this.emailVerificationSent,
  });

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      tokens: json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null,
      emailVerificationSent: json['email_verification_sent'],
    );
  }
}

class User {
  final String? id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? dateOfBirth;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      dateOfBirth: json['date_of_birth'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Tokens {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;

  Tokens({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) {
    return Tokens(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }
}
