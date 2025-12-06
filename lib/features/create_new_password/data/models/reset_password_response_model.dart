class ResetPasswordResponseModel {
  final bool success;
  final String message;
  final dynamic data;

  ResetPasswordResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }
}
