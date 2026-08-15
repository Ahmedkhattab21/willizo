import 'dart:convert';

import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/subscription/data/models/subscription_models.dart';
import 'package:willizo/features/subscription/data/services/subscription_api_endpoints.dart';

class SubscriptionService {
  final ApiConsumer apiConsumer;

  SubscriptionService(this.apiConsumer);

  Future<CurrentSubscriptionResponse> getCurrentSubscription() async {
    final response = await apiConsumer.get(
      SubscriptionApiEndpoints.currentSubscription,
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) {
      return CurrentSubscriptionResponse.fromJson(body);
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<PlansResponse> getPlans() async {
    final response = await apiConsumer.get(
      SubscriptionApiEndpoints.plans,
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) return PlansResponse.fromJson(body);
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<MembersResponse> getMembers() async {
    final response = await apiConsumer.get(
      SubscriptionApiEndpoints.members,
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) return MembersResponse.fromJson(body);
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<PaymentsResponse> getPaymentHistory() async {
    final response = await apiConsumer.get(
      SubscriptionApiEndpoints.paymentHistory,
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) return PaymentsResponse.fromJson(body);
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<UpcomingPaymentResponse> getUpcomingPayment() async {
    final response = await apiConsumer.get(
      SubscriptionApiEndpoints.upcomingPayment,
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) {
      return UpcomingPaymentResponse.fromJson(body);
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<SubscriptionPaymentModel> getPayment(String id) async {
    final response = await apiConsumer.get(
      SubscriptionApiEndpoints.payment(id),
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) {
      final data = body['data'] is Map<String, dynamic> ? body['data'] : body;
      return SubscriptionPaymentModel.fromJson(data);
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<String> inviteMember(String email) async {
    final response = await apiConsumer.post(
      SubscriptionApiEndpoints.inviteMember,
      {'email': email},
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) {
      return body['message']?.toString() ?? 'Invitation sent successfully';
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<String> changePlan(String planId) async {
    final response = await apiConsumer.post(
      SubscriptionApiEndpoints.changePlan,
      {'new_plan_id': planId},
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) {
      return body['message']?.toString() ?? 'Plan changed successfully';
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<String> subscribe(String planId) async {
    final response = await apiConsumer.post(
      SubscriptionApiEndpoints.subscribe,
      {'plan': planId},
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) {
      return body['message']?.toString() ?? 'Subscribed successfully';
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<String> toggleAutoRenew(bool autoRenew) async {
    final response = await apiConsumer.put(SubscriptionApiEndpoints.autoRenew, {
      'auto_renew': autoRenew,
    }, await _authHeaders());
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) {
      return body['message']?.toString() ?? 'Auto renewal updated';
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<String> cancelSubscription() async {
    final response = await apiConsumer.post(
      SubscriptionApiEndpoints.cancel,
      {},
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) {
      return body['message']?.toString() ?? 'Subscription cancelled';
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<String> shareReceipt(String paymentId, String email) async {
    final response = await apiConsumer.post(
      SubscriptionApiEndpoints.shareReceipt(paymentId),
      {'email': email},
      await _authHeaders(),
    );
    final body = _decode(response.body);
    if (_isSuccess(response.statusCode)) {
      return body['message']?.toString() ?? 'Receipt shared';
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    return {
      ConstantKeys.appAuthorization: '${ConstantKeys.appBearer} $token',
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
    };
  }

  Map<String, dynamic> _decode(String body) {
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
  }

  bool _isSuccess(int statusCode) {
    return statusCode == StatusCode.ok || statusCode == StatusCode.created;
  }
}
