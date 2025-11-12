class LoginResponseModel {
  final bool success;
  final String message;
  final LoginData? data;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

class LoginData {
  final User? user;
  final Tokens? tokens;

  LoginData({
    this.user,
    this.tokens,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      tokens: json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null,
    );
  }
}

class User {
  final String? id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? dateOfBirth;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.dateOfBirth,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
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
      emailVerifiedAt: json['email_verified_at'],
      phoneVerifiedAt: json['phone_verified_at'],
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
