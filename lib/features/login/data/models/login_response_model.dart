class LoginResponseModel {
  String token;
  LoginData loginData;
  bool isClient;

  LoginResponseModel({
    required this.loginData,
    required this.token,
    required this.isClient,
  });

  factory LoginResponseModel.fromJson(
    Map<String, dynamic> json,
    bool isClient,
  ) => LoginResponseModel(
    token: json['token'],
    isClient: isClient,
    loginData: LoginData.fromJson(json['data']),
  );
}

class LoginData {
  int id;
  String name;
  String email;
  String phone;
  String job;
  String countryCode;
  String status;

  LoginData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.job,
    required this.countryCode,
    required this.status,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    id: json['id'],
    name: json['name'] ?? "",
    email: json['email'] ?? "",
    phone: json['phone'] ?? "",
    job: json['job'] ?? "",
    countryCode: json['country_code'] ?? "",
    status: json['status'] ?? "",
  );
}
