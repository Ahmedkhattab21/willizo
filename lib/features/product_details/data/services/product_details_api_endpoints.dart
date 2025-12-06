import 'package:willizo/core/api/end_points.dart';

class ProductDetailsApiEndpoints {
  static String getRelatedProducts(String productSlug) =>
      '${EndPoints.baseUrl}/products/$productSlug/related';
}
