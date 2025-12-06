import 'dart:convert';
import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/end_points.dart';
import 'package:willizo/core/api/models/refresh_token_request_model.dart';
import 'package:willizo/core/api/models/refresh_token_response_model.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';

class RefreshTokenService {
  final ApiConsumer apiConsumer;

  RefreshTokenService({required this.apiConsumer});

  Future<RefreshTokenResponseModel> refreshToken(String refreshToken) async {
    final response = await apiConsumer.post(
      EndPoints.refreshTokenUrl,
      RefreshTokenRequestModel(refreshToken: refreshToken).toJson(),
      null, // No authorization header needed for refresh
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return RefreshTokenResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}

