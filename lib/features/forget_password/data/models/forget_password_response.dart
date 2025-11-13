class ForgetPasswordResponse {
  final bool success;
  final String message;
  final dynamic data;

  ForgetPasswordResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
