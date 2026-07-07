import 'package:willizo/core/api/end_points.dart';

class ProductDetailsApiEndpoints {
  static String getRelatedProducts(String productSlug) =>
      '${EndPoints.baseUrl}/products/$productSlug/related';
  static String getProductDetails(String productId) =>
      '${EndPoints.baseUrl}/products/$productId/details';
  static String getProductReviews(String productId) =>
      '${EndPoints.baseUrl}/products/$productId/reviews';
  static String createReview = '${EndPoints.baseUrl}/reviews';
  static String addProductToCart = '${EndPoints.baseUrl}/cart/items';
  static String addProductToWishlist = '${EndPoints.baseUrl}/wishlist';
  static String removeFromWishlist(String productId) =>
      '${EndPoints.baseUrl}/wishlist/$productId';
}

// wishlist/{{product_id}}
