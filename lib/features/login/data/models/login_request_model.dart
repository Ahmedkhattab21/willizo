class LoginRequestModel {
  String email;
  String password;
  String fcm;

  LoginRequestModel({
    required this.email,
    required this.password,
    required this.fcm,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "fcm_token": fcm,
  };
}
