class RefreshTokenResponseModel {
  final bool success;
  final String message;
  final RefreshTokenData? data;

  RefreshTokenResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RefreshTokenData.fromJson(json['data']) : null,
    );
  }
}

class RefreshTokenData {
  final RefreshTokens? tokens;

  RefreshTokenData({this.tokens});

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) {
    return RefreshTokenData(
      tokens: json['tokens'] != null ? RefreshTokens.fromJson(json['tokens']) : null,
    );
  }
}

class RefreshTokens {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;

  RefreshTokens({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  factory RefreshTokens.fromJson(Map<String, dynamic> json) {
    return RefreshTokens(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }
}

