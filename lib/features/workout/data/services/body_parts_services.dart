import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';
import 'package:willizo/features/workout/data/services/workout_api_endpoints.dart';

class BodyPartsServices {
  final ApiConsumer apiConsumer;

  BodyPartsServices(this.apiConsumer);

  Future<BodyPartsResponseModel> getBodyParts() async {
    final response = await apiConsumer.get(
      WorkoutApiEndpoints.bodyParts,
      await _authHeaders(),
    );
    _throwIfNotOk(response);
    return BodyPartsResponseModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Map<String, String>> _authHeaders() async {
    return {
      ConstantKeys.appAuthorization:
          '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
    };
  }

  void _throwIfNotOk(http.Response response) {
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return;
    }

    try {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    } catch (_) {
      throw const ServerException(
        serverFailure: ServerFailure(message: 'Unknown error'),
      );
    }
  }
}
