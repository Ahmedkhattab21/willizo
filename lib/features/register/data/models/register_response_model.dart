class RegisterResponseModel {
  String message;
  String accountStatus;
  String traceId;
  RegisterData registerData;


  RegisterResponseModel({
    required this.message,
    required this.accountStatus,
    required this.registerData,
    required this.traceId,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        message: json['message'],
        accountStatus: json['account_status'],
        traceId: json['trace_id'],
        registerData: RegisterData.fromJson(json['data']),
      );
}

class RegisterData {
  int id;
  String name;
  String email;
  String phone;
  String job;
  String countryCode;
  String status;

  RegisterData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.job,
    required this.countryCode,
    required this.status,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      RegisterData(
        id: json['id'],
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        phone: json['phone'] ?? "",
        job: json['job'] ?? "",
        countryCode: json['country_code'] ?? "",
        status: json['status'] ?? "",

      );
}
