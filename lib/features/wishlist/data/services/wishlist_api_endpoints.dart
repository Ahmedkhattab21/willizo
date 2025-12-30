import 'package:willizo/core/api/end_points.dart';

class WishlistApiEndpoints {
  static const String wishlistUrl = '${EndPoints.baseUrl}/wishlist';
  static String removeFromWishlist(String productId) => '$wishlistUrl/$productId';
}
