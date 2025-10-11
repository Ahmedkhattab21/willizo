import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/home/data/models/home_model.dart';
import 'package:willizo/features/home/data/services/home_api_endpoints.dart';

class HomeServices {
  final ApiConsumer apiConsumer;
  HomeServices(this.apiConsumer);

  Future<HomeResponseModel> getHome() async {
    final response = await apiConsumer.get(HomeApiEndpoints.homeUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });
    return HomeResponseModel.fromJson(jsonDecode(response.body));
  }
}
