class RegisterRequestModel {
  String name;
  String email;
  String password;
  String phone;
  String countryCode;
  String job;





  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.job,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "country_code": countryCode,
    "job": job,
    "fcm_token": 'as',
    "password": password,
    "password_confirmation": password,
  };
}

