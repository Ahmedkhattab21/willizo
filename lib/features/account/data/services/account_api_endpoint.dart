import 'package:willizo/core/api/end_points.dart';

class AccountApiEndpoint {
  static const String account = '${EndPoints.baseUrl}/profile';
  static const String logout = '${EndPoints.baseUrl}/auth/logout';
  static const String profilePhoto = '${EndPoints.baseUrl}/profile/photo';
}
