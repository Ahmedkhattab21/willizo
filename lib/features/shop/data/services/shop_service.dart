import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/all_products/data/models/all_products_model_response.dart';
import 'package:willizo/features/shop/data/models/banners_response_model.dart';
import 'package:willizo/features/shop/data/models/categories_model_response.dart';
import 'package:willizo/features/shop/data/models/shop_model_response.dart';
import 'package:willizo/features/shop/data/services/shop_api_endpoints.dart';

class ShopService {
  ApiConsumer apiConsumer;

  ShopService({required this.apiConsumer});

  Future<ShopResponseModel> getFeaturedProducts() async {
    final response = await apiConsumer.get(ShopApiEndpoints.shopUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ShopResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<CategoriesResponseModel> getCategories() async {
    final response = await apiConsumer.get(ShopApiEndpoints.categoriesUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return CategoriesResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<List<BannerModel>> getBanners() async {
    final response = await apiConsumer.get(ShopApiEndpoints.bannersUrl, {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
    });

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final decoded = jsonDecode(response.body);
      final list = decoded is List
          ? decoded
          : decoded is Map<String, dynamic> && decoded['data'] is List
          ? decoded['data'] as List
          : const [];

      final banners = list
          .whereType<Map<String, dynamic>>()
          .map(BannerModel.fromJson)
          .where((banner) => banner.isActive && banner.imageUrl.isNotEmpty)
          .toList();
      banners.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return banners;
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<AllProductsResponseModel> getCategoryProducts(
    String categorySlug,
  ) async {
    final response = await apiConsumer.get(
      ShopApiEndpoints.getCategoryProductsUrl(categorySlug),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

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
