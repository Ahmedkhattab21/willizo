import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/errors_and_success_response/success/success_response.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/account/data/models/account_resonse.dart';
import 'package:willizo/features/account/data/models/update_profile_request_model.dart';
import 'package:willizo/features/account/data/services/account_api_endpoint.dart';

class AccountService {
  ApiConsumer apiConsumer;

  AccountService({required this.apiConsumer});

  Future<AccountResponseModel> getAccountData() async {
    final response = await apiConsumer.get(AccountApiEndpoint.account, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return AccountResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<SuccessResponseModel> logout() async {
    final response = await apiConsumer.post(AccountApiEndpoint.logout, null, {
      ConstantKeys.contentType: ConstantKeys.applicationJson,
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.noContent || response.body.isEmpty) {
      return const SuccessResponseModel(
        status: true,
        orderId: null,
        message: 'Logged out successfully',
      );
    }

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return SuccessResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<AccountResponseModel> updateProfile(
    UpdateProfileRequestModel requestModel,
  ) async {
    final response = await apiConsumer.put(
      AccountApiEndpoint.account,
      requestModel.toJson(),
      {
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return AccountResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
