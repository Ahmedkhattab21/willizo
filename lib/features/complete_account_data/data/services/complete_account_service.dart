import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_response.dart';
import 'package:willizo/features/complete_account_data/data/services/complete_account_api_endpoints.dart';

class CompleteAccountService {
  final ApiConsumer apiConsumer;

  CompleteAccountService({required this.apiConsumer});

  Future<StepResponseModel> sendSteps({
    required StepsRequestModel parameter,
  }) async {
    final response = await apiConsumer.post(
      CompleteAccountApiEndpoints.completeAccountUrl,
      parameter.toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return StepResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
