class CurrentSubscriptionResponse {
  final SubscriptionModel? subscription;

  const CurrentSubscriptionResponse({required this.subscription});

  factory CurrentSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    final raw = _unwrapData(json);
    return CurrentSubscriptionResponse(
      subscription: raw is Map<String, dynamic>
          ? SubscriptionModel.fromJson(raw)
          : null,
    );
  }
}

class PlansResponse {
  final List<PlanModel> plans;

  const PlansResponse({required this.plans});

  factory PlansResponse.fromJson(Map<String, dynamic> json) {
    final raw = _unwrapData(json);
    final list = raw is List
        ? raw
        : raw is Map
        ? raw['plans']
        : null;
    return PlansResponse(
      plans: list is List
          ? list
                .whereType<Map>()
                .map((e) => PlanModel.fromJson(e.cast<String, dynamic>()))
                .toList()
          : const [],
    );
  }
}

class MembersResponse {
  final List<MemberModel> members;

  const MembersResponse({required this.members});

  factory MembersResponse.fromJson(Map<String, dynamic> json) {
    final raw = _unwrapData(json);
    final list = raw is List
        ? raw
        : raw is Map
        ? raw['members']
        : null;
    return MembersResponse(
      members: list is List
          ? list
                .whereType<Map>()
                .map((e) => MemberModel.fromJson(e.cast<String, dynamic>()))
                .toList()
          : const [],
    );
  }
}

class PaymentsResponse {
  final List<SubscriptionPaymentModel> payments;

  const PaymentsResponse({required this.payments});

  factory PaymentsResponse.fromJson(Map<String, dynamic> json) {
    final raw = _unwrapData(json);
    final list = raw is List
        ? raw
        : raw is Map
        ? raw['payments']
        : null;
    return PaymentsResponse(
      payments: list is List
          ? list
                .whereType<Map>()
                .map(
                  (e) => SubscriptionPaymentModel.fromJson(
                    e.cast<String, dynamic>(),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class UpcomingPaymentResponse {
  final String date;
  final double amount;

  const UpcomingPaymentResponse({required this.date, required this.amount});

  factory UpcomingPaymentResponse.fromJson(Map<String, dynamic> json) {
    final raw = _unwrapData(json);
    final data = raw is Map<String, dynamic> ? raw : json;
    return UpcomingPaymentResponse(
      date: _toString(data['date'] ?? data['next_payment_date']),
      amount: _toDouble(data['amount'] ?? data['total']),
    );
  }
}

class SubscriptionModel {
  final String id;
  final String status;
  final PlanModel plan;
  final bool autoRenew;
  final String activeSince;
  final String nextBillingDate;
  final int membersCount;
  final int maxMembers;

  const SubscriptionModel({
    required this.id,
    required this.status,
    required this.plan,
    required this.autoRenew,
    required this.activeSince,
    required this.nextBillingDate,
    required this.membersCount,
    required this.maxMembers,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    final planJson = json['plan'] is Map
        ? (json['plan'] as Map).cast<String, dynamic>()
        : json;
    return SubscriptionModel(
      id: _toString(json['id']),
      status: _toString(json['status'], fallback: 'active'),
      plan: PlanModel.fromJson(planJson),
      autoRenew: _toBool(json['auto_renew'] ?? json['auto_renewal'], true),
      activeSince: _toString(json['active_since'] ?? json['created_at']),
      nextBillingDate: _toString(
        json['next_billing_date'] ??
            json['current_period_end'] ??
            json['renews_at'],
      ),
      membersCount: _toInt(
        json['members_count'] ?? json['member_count'] ?? json['members'],
      ),
      maxMembers: _toInt(
        json['max_members'] ?? planJson['max_members'] ?? planJson['members'],
      ),
    );
  }
}

class PlanModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String interval;
  final int maxMembers;
  final bool isCurrent;
  final bool isBestOffer;
  final List<String> benefits;

  const PlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.interval,
    required this.maxMembers,
    required this.isCurrent,
    required this.isBestOffer,
    required this.benefits,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: _toString(json['id']),
      name: _toString(json['name'] ?? json['title'], fallback: 'Premium Plan'),
      description: _toString(json['description']),
      price: _toDouble(
        json['price'] ?? json['monthly_price'] ?? json['amount'],
      ),
      interval: _toString(
        json['interval'] ?? json['billing_interval'],
        fallback: 'month',
      ),
      maxMembers: _toInt(
        json['max_members'] ?? json['members_limit'] ?? json['members'],
      ),
      isCurrent: _toBool(json['is_current'] ?? json['current']),
      isBestOffer: _toBool(json['is_best_offer'] ?? json['best_offer']),
      benefits: _toStringList(json['benefits'] ?? json['features']),
    );
  }
}

class MemberModel {
  final String id;
  final String name;
  final String email;
  final bool isOwner;
  final bool isOnline;
  final String lastActiveAt;

  const MemberModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isOwner,
    required this.isOnline,
    required this.lastActiveAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? (json['user'] as Map).cast<String, dynamic>()
        : json;
    return MemberModel(
      id: _toString(json['id'] ?? user['id']),
      name: _toString(
        user['full_name'] ?? user['name'] ?? json['name'],
        fallback: 'Member',
      ),
      email: _toString(user['email'] ?? json['email']),
      isOwner:
          _toBool(json['is_owner']) ||
          _toString(json['role']).toLowerCase() == 'owner',
      isOnline: _toBool(user['is_online'] ?? json['is_online']),
      lastActiveAt: _toString(user['last_active_at'] ?? json['last_active_at']),
    );
  }
}

class SubscriptionPaymentModel {
  final String id;
  final String transactionId;
  final String status;
  final String date;
  final String paymentMethod;
  final String planName;
  final double amount;
  final double subtotal;
  final double tax;
  final double discount;

  const SubscriptionPaymentModel({
    required this.id,
    required this.transactionId,
    required this.status,
    required this.date,
    required this.paymentMethod,
    required this.planName,
    required this.amount,
    required this.subtotal,
    required this.tax,
    required this.discount,
  });

  factory SubscriptionPaymentModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPaymentModel(
      id: _toString(json['id']),
      transactionId: _toString(json['transaction_id'] ?? json['transaction']),
      status: _toString(json['status'], fallback: 'completed'),
      date: _toString(json['date'] ?? json['created_at'] ?? json['paid_at']),
      paymentMethod: _toString(
        json['payment_method'] ?? json['card_last4'],
        fallback: 'Card',
      ),
      planName: _toString(json['plan_name'] ?? json['plan']?['name']),
      amount: _toDouble(json['amount'] ?? json['total']),
      subtotal: _toDouble(json['subtotal'] ?? json['amount']),
      tax: _toDouble(json['tax'] ?? json['tax_amount']),
      discount: _toDouble(json['discount'] ?? json['discount_amount']),
    );
  }
}

dynamic _unwrapData(Map<String, dynamic> json) => json['data'] ?? json;

String _toString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  final text = value.toString();
  return text.isEmpty ? fallback : text;
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

bool _toBool(dynamic value, [bool fallback = false]) {
  if (value is bool) return value;
  if (value is num) return value == 1;
  if (value is String) {
    final normalized = value.toLowerCase().trim();
    return normalized == '1' || normalized == 'true' || normalized == 'yes';
  }
  return fallback;
}

List<String> _toStringList(dynamic value) {
  if (value is List) {
    return value.map((e) => _toString(e)).where((e) => e.isNotEmpty).toList();
  }
  if (value is String && value.isNotEmpty) {
    return value
        .split(RegExp(r'[\n,]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  return const [];
}
