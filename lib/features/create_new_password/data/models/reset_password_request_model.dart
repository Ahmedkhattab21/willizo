class ResetPasswordRequestModel {
  final String emailOrPhone;
  final String code;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequestModel({
    required this.emailOrPhone,
    required this.code,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "email_or_phone": emailOrPhone,
      "code": code,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    };
  }
}
