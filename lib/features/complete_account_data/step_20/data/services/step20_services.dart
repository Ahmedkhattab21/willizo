import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/complete_account_data/step_18/data/models/gym_equipments_response_model.dart';
import 'package:willizo/features/complete_account_data/step_18/data/services/step18_api_endpoints.dart';
import 'package:willizo/features/complete_account_data/step_19/data/models/free_weight_response_model.dart';
import 'package:willizo/features/complete_account_data/step_19/data/services/step19_api_endpoints.dart';
import 'package:willizo/features/complete_account_data/step_20/data/models/supprotive_tool_response_model.dart';
import 'package:willizo/features/complete_account_data/step_20/data/services/step20_api_endpoints.dart';

class Step20Services {
  final ApiConsumer _apiConsumer;

  Step20Services(this._apiConsumer);

  Future<SupportiveToolsResponse> getSupportiveTools() async {
    final response = await _apiConsumer.get(Step20ApiEndpoints.supportiveTools, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });
    return SupportiveToolsResponse.fromJson(jsonDecode(response.body));
  }
}
