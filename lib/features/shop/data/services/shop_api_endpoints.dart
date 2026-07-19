import 'package:willizo/core/api/end_points.dart';

class ShopApiEndpoints {
  static const String shopUrl = '${EndPoints.baseUrl}/products/featured';
  static const String allProductsUrl = '${EndPoints.baseUrl}/products';
  static const String categoriesUrl = '${EndPoints.baseUrl}/categories';
  static const String bannersUrl = '${EndPoints.baseUrl}/banners';
  static String getCategoryProductsUrl(String categorySlug) =>
      '${EndPoints.baseUrl}/categories/$categorySlug/products';
}
