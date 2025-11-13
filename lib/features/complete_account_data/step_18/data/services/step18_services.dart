import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/complete_account_data/step_18/data/models/gym_equipments_response_model.dart';
import 'package:willizo/features/complete_account_data/step_18/data/services/step18_api_endpoints.dart';

class Step18Services {
  final ApiConsumer _apiConsumer;

  Step18Services(this._apiConsumer);

  Future<GymEquipmentsResponse> getGymEquipments() async {
    final response = await _apiConsumer.get(Step18ApiEndpoints.getGymEquipment, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });
    return GymEquipmentsResponse.fromJson(jsonDecode(response.body));
  }
}
