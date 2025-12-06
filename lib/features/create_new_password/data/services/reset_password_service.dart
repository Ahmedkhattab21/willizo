import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/create_new_password/data/models/reset_password_request_model.dart';
import 'package:willizo/features/create_new_password/data/models/reset_password_response_model.dart';
import 'package:willizo/features/create_new_password/data/services/reset_password_api_endpoints.dart';

class ResetPasswordService {
  ApiConsumer apiConsumer;

  ResetPasswordService({required this.apiConsumer});

  Future<ResetPasswordResponseModel> resetPassword({
    required ResetPasswordRequestModel requestModel,
  }) async {
    final response = await apiConsumer.post(
      ResetPasswordApiEndpoints.resetPasswordUrl,
      requestModel.toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ResetPasswordResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
