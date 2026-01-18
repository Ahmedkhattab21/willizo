import 'package:willizo/core/api/end_points.dart';

class CheckoutApiEndpoints {
  static const String addressesUrl = '${EndPoints.baseUrl}/addresses';
  static const String checkoutCalculateUrl =
      '${EndPoints.baseUrl}/checkout/calculate';
  static const String confirmCheckoutUrl = '${EndPoints.baseUrl}/checkout';
}
