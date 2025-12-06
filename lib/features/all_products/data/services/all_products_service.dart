import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/all_products/data/models/all_products_model_response.dart';
import 'package:willizo/features/shop/data/services/shop_api_endpoints.dart';

class AllProductsService {
  ApiConsumer apiConsumer;

  AllProductsService({required this.apiConsumer});

  Future<AllProductsResponseModel> getAllProducts({int? page}) async {
    String url = ShopApiEndpoints.allProductsUrl;
    if (page != null) {
      url = '$url?page=$page';
    }

    final response = await apiConsumer.get(url, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return AllProductsResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
