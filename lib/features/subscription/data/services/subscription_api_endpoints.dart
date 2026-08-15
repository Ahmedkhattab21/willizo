import 'package:willizo/core/api/end_points.dart';

class SubscriptionApiEndpoints {
  static const plans = '${EndPoints.baseUrl}/plans';
  static const currentSubscription =
      '${EndPoints.baseUrl}/subscriptions/current';
  static const subscribe = '${EndPoints.baseUrl}/subscriptions/subscribe';
  static const changePlan = '${EndPoints.baseUrl}/subscriptions/change';
  static const cancel = '${EndPoints.baseUrl}/subscriptions/cancel';
  static const resume = '${EndPoints.baseUrl}/subscriptions/resume';
  static const autoRenew = '${EndPoints.baseUrl}/subscriptions/auto-renew';
  static const members = '${EndPoints.baseUrl}/subscriptions/members';
  static const inviteMember =
      '${EndPoints.baseUrl}/subscriptions/members/invite';
  static const invitations = '${EndPoints.baseUrl}/subscriptions/invitations';
  static const paymentHistory =
      '${EndPoints.baseUrl}/subscriptions/payment-history';
  static const upcomingPayment =
      '${EndPoints.baseUrl}/subscriptions/upcoming-payment';

  static String payment(String id) =>
      '${EndPoints.baseUrl}/subscriptions/payments/$id';

  static String downloadReceipt(String id) =>
      '${EndPoints.baseUrl}/subscriptions/payments/$id/download';

  static String shareReceipt(String id) =>
      '${EndPoints.baseUrl}/subscriptions/payments/$id/share';

  static String removeMember(String id) =>
      '${EndPoints.baseUrl}/subscriptions/members/$id';
}
