import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/subscription/data/models/subscription_models.dart';
import 'package:willizo/features/subscription/data/repo/subscription_repo.dart';
import 'package:willizo/features/subscription/ui/change_plan_screen.dart';
import 'package:willizo/features/subscription/ui/payment_details_screen.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  SubscriptionModel? _subscription;
  List<SubscriptionPaymentModel> _payments = const [];
  bool _loading = true;
  bool _autoRenewLoading = false;
  String? _error;

  SubscriptionRepo get _repo => getIt<SubscriptionRepo>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final subscriptionResult = await _repo.getCurrentSubscription();
    final paymentsResult = await _repo.getPaymentHistory();
    if (!mounted) return;
    subscriptionResult.fold(
      (failure) => _error = failure.message,
      (response) => _subscription = response.subscription,
    );
    paymentsResult.fold(
      (failure) => _error ??= failure.message,
      (response) => _payments = response.payments,
    );
    setState(() => _loading = false);
  }

  Future<void> _toggleAutoRenew(bool value) async {
    if (_autoRenewLoading) return;
    setState(() => _autoRenewLoading = true);
    final result = await _repo.toggleAutoRenew(value);
    if (!mounted) return;
    setState(() => _autoRenewLoading = false);
    result.fold(
      (failure) => AppConstant.toast(failure.message, AppColors.redColor),
      (message) {
        AppConstant.toast(message, AppColors.primaryColor);
        _load();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: _SubAppBar(title: 'Billing'),
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: _load,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : _error != null
            ? _ErrorView(message: _error!, onRetry: _load)
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 32.h),
                children: [
                  _BillingRow(
                    title: 'Auto-Renewal',
                    subtitle:
                        'Next renewal: ${_formatDate(_subscription?.nextBillingDate)}',
                    trailing: _autoRenewLoading
                        ? SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          )
                        : Switch(
                            value: _subscription?.autoRenew ?? false,
                            activeThumbColor: AppColors.whiteColor,
                            activeTrackColor: AppColors.greenColorFA,
                            onChanged: _toggleAutoRenew,
                          ),
                  ),
                  verticalSpace(14),
                  _BillingRow(
                    title: 'Last-Payment',
                    subtitle: _payments.isEmpty
                        ? 'No payments yet'
                        : _formatDate(_payments.first.date),
                    trailing: Icon(
                      Icons.receipt_long,
                      color: AppColors.whiteColor,
                    ),
                    onTap: _payments.isEmpty
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentDetailsScreen(
                                payment: _payments.first,
                              ),
                            ),
                          ),
                  ),
                  verticalSpace(14),
                  _BillingRow(
                    title: 'Change Plan',
                    subtitle:
                        'Current Plan: ${_subscription?.plan.name ?? '-'}',
                    trailing: Icon(Icons.sync, color: AppColors.whiteColor),
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePlanScreen(),
                        ),
                      );
                      if (updated == true) _load();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class _BillingRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _BillingRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.font14WhiteColorW500),
                  verticalSpace(4),
                  Text(subtitle, style: TextStyles.font12greyColorColor79W400),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _SubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const _SubAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0F0F0F),
      elevation: 0,
      centerTitle: true,
      title: Text(title, style: TextStyles.font20WhiteColorW600),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(24.r),
      children: [
        verticalSpace(120),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyles.font14whiteColorColorW400,
        ),
        verticalSpace(12),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

String _formatDate(String? value) {
  if (value == null || value.isEmpty) return '-';
  final date = DateTime.tryParse(value);
  if (date == null) return value.split('T').first;
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
