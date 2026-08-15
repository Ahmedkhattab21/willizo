import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/subscription/data/models/subscription_models.dart';
import 'package:willizo/features/subscription/data/repo/subscription_repo.dart';

class PlanDetailsScreen extends StatefulWidget {
  const PlanDetailsScreen({super.key});

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  SubscriptionModel? _subscription;
  bool _loading = true;
  bool _cancelling = false;
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
    final result = await _repo.getCurrentSubscription();
    if (!mounted) return;
    result.fold(
      (failure) => _error = failure.message,
      (response) => _subscription = response.subscription,
    );
    setState(() => _loading = false);
  }

  Future<void> _cancelPlan() async {
    if (_cancelling) return;
    setState(() => _cancelling = true);
    final result = await _repo.cancelSubscription();
    if (!mounted) return;
    setState(() => _cancelling = false);
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        centerTitle: true,
        title: Text('Plan Details', style: TextStyles.font20WhiteColorW600),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
        ),
      ),
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
                  _InfoCard(
                    title: 'Plan Type',
                    value: _subscription?.plan.name ?? '-',
                  ),
                  verticalSpace(12),
                  _InfoCard(
                    title: 'Members',
                    value:
                        '${_subscription?.membersCount ?? 0}/${_subscription?.maxMembers ?? 0}',
                  ),
                  verticalSpace(12),
                  _InfoCard(
                    title: 'Next Billing',
                    value: _formatDate(_subscription?.nextBillingDate),
                  ),
                  verticalSpace(12),
                  _BenefitsCard(
                    benefits: _subscription?.plan.benefits ?? const [],
                  ),
                  verticalSpace(12),
                  _CancelCard(isLoading: _cancelling, onCancel: _cancelPlan),
                ],
              ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.font16WhiteColorW600),
          verticalSpace(8),
          Text(value, style: TextStyles.font14greyColorColor80W400),
        ],
      ),
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  final List<String> benefits;

  const _BenefitsCard({required this.benefits});

  @override
  Widget build(BuildContext context) {
    final items = benefits.isEmpty
        ? const [
            'Access to all premium features and content.',
            'Shared billing managed by the plan owner.',
            'Join a private group with friends and family.',
          ]
        : benefits;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plan Benefits :', style: TextStyles.font16WhiteColorW600),
          verticalSpace(14),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.greenColor12,
                    size: 20.r,
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyles.font14greyColorColor80W400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCancel;

  const _CancelCard({required this.isLoading, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.cancel_outlined,
                color: AppColors.redColor,
                size: 22.r,
              ),
              horizontalSpace(10),
              Text(
                'Cancel Plan',
                style: TextStyles.font16WhiteColorW600.copyWith(
                  color: AppColors.redColor,
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Text(
            'If you are sure you want to cancel your plan, click on Cancel Plan.',
            style: TextStyles.font12greyColorColor79W400,
          ),
          verticalSpace(16),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blackColor,
                foregroundColor: AppColors.redColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Cancel Plan'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF172000),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: child,
    );
  }
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
