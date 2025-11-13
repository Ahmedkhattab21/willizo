import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/forget_password/data/models/forget_password_response.dart';
import 'package:willizo/features/forget_password/data/services/forget_password_api_endpoints.dart';

class ForgetPasswordService {
  ApiConsumer apiConsumer;

  ForgetPasswordService({required this.apiConsumer});

  Future<ForgetPasswordResponse> forgetPassword({required String emailOrPhone}) async {
    final response = await apiConsumer.post(
      ForgetPasswordApiEndpoints.forgetPasswordUrl,
      {"email_or_phone": emailOrPhone},
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ForgetPasswordResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
