import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/product_details/data/services/product_details_api_endpoints.dart';
import 'package:willizo/features/shop/data/models/shop_model_response.dart';

class ProductDetailsService {
  ApiConsumer apiConsumer;

  ProductDetailsService({required this.apiConsumer});

  Future<ShopResponseModel> getRelatedProducts(String productSlug) async {
    final response = await apiConsumer.get(
      ProductDetailsApiEndpoints.getRelatedProducts(productSlug),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ShopResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
