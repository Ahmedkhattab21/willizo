import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/login_and_signup/data/models/login_request_model.dart';
import 'package:willizo/features/login_and_signup/data/models/login_response_model.dart';
import 'package:willizo/features/login_and_signup/data/models/signup_request_model.dart';
import 'package:willizo/features/login_and_signup/data/models/signup_resopnse_model.dart';
import 'package:willizo/features/login_and_signup/data/services/login_and_signup_api_end_points.dart';

class LoginAndSignupService {
  ApiConsumer apiConsumer;

  LoginAndSignupService({required this.apiConsumer});

  Future<LoginResponseModel> login(LoginRequestModel parameter) async {
    final response = await apiConsumer.post(
      LoginAndSignupApiEndPoints.loginUrl,
      LoginRequestModel(
        email: parameter.email,
        password: parameter.password,
      ).toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<SignupResponseModel> signup(SignupRequestModel parameter) async {
    final response = await apiConsumer.post(
      LoginAndSignupApiEndPoints.registerUrl,
      parameter.toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return SignupResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
