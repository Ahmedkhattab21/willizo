import 'package:willizo/core/api/end_points.dart';

class LoginAndSignupApiEndPoints {
  static const loginUrl = "${EndPoints.baseUrl}/auth/login";
  static const registerUrl = "${EndPoints.baseUrl}/auth/signup";
  static const getOnboardingStepUrl = "${EndPoints.baseUrl}/onboarding/status";
}
