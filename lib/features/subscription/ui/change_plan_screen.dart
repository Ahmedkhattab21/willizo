import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/subscription/data/models/subscription_models.dart';
import 'package:willizo/features/subscription/data/repo/subscription_repo.dart';

class ChangePlanScreen extends StatefulWidget {
  const ChangePlanScreen({super.key});

  @override
  State<ChangePlanScreen> createState() => _ChangePlanScreenState();
}

class _ChangePlanScreenState extends State<ChangePlanScreen> {
  List<PlanModel> _plans = const [];
  SubscriptionModel? _subscription;
  bool _loading = true;
  String? _changingPlanId;
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
    final plansResult = await _repo.getPlans();
    final currentResult = await _repo.getCurrentSubscription();
    if (!mounted) return;
    plansResult.fold(
      (failure) => _error = failure.message,
      (response) => _plans = response.plans,
    );
    currentResult.fold(
      (_) {},
      (response) => _subscription = response.subscription,
    );
    setState(() => _loading = false);
  }

  Future<void> _changePlan(PlanModel plan) async {
    if (_changingPlanId != null || plan.id.isEmpty) return;
    setState(() => _changingPlanId = plan.id);
    final result = _subscription == null
        ? await _repo.subscribe(plan.id)
        : await _repo.changePlan(plan.id);
    if (!mounted) return;
    setState(() => _changingPlanId = null);
    result.fold(
      (failure) => AppConstant.toast(failure.message, AppColors.redColor),
      (message) {
        AppConstant.toast(message, AppColors.primaryColor);
        Navigator.pop(context, true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: _SubAppBar(title: 'Change Plan'),
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
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 32.h),
                children: [
                  _CurrentPlanCard(subscription: _subscription),
                  verticalSpace(18),
                  Text(
                    'Available Plans',
                    style: TextStyles.font16WhiteColorW600,
                  ),
                  verticalSpace(12),
                  ..._plans.map(
                    (plan) => Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: _PlanOptionCard(
                        plan: plan,
                        isCurrent:
                            plan.isCurrent ||
                            plan.id == _subscription?.plan.id ||
                            plan.name == _subscription?.plan.name,
                        isLoading: _changingPlanId == plan.id,
                        onTap: () => _changePlan(plan),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _PlanOptionCard extends StatelessWidget {
  final PlanModel plan;
  final bool isCurrent;
  final bool isLoading;
  final VoidCallback onTap;

  const _PlanOptionCard({
    required this.plan,
    required this.isCurrent,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final highlighted = plan.isBestOffer;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryColor : AppColors.greyColor2727,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.name,
                  style: TextStyles.font16WhiteColorW600.copyWith(
                    color: highlighted
                        ? AppColors.blackColor
                        : AppColors.whiteColor,
                  ),
                ),
              ),
              if (highlighted)
                _Badge(label: 'Best Offer')
              else if (isCurrent)
                _Badge(label: 'Current'),
            ],
          ),
          verticalSpace(4),
          Text(
            plan.description.isEmpty ? '1 account only' : plan.description,
            style: TextStyles.font12InterWhiteW400.copyWith(
              color: highlighted
                  ? AppColors.blackColor.withValues(alpha: 0.75)
                  : AppColors.greyColorColor80,
            ),
          ),
          verticalSpace(12),
          Text(
            '\$${plan.price.toStringAsFixed(0)}',
            style: TextStyles.font24WhiteColorW700.copyWith(
              color: highlighted ? AppColors.blackColor : AppColors.whiteColor,
            ),
          ),
          verticalSpace(12),
          ..._benefits(plan).map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: highlighted
                        ? AppColors.blackColor
                        : AppColors.whiteColor,
                    size: 15.r,
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyles.font12InterWhiteW400.copyWith(
                        color: highlighted
                            ? AppColors.blackColor
                            : AppColors.greyColorD1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          verticalSpace(10),
          SizedBox(
            width: double.infinity,
            height: 42.h,
            child: OutlinedButton(
              onPressed: isCurrent || isLoading ? null : onTap,
              style: OutlinedButton.styleFrom(
                backgroundColor: highlighted
                    ? AppColors.blackColor
                    : Colors.transparent,
                foregroundColor: highlighted
                    ? AppColors.primaryColor
                    : AppColors.whiteColor,
                side: BorderSide(
                  color: highlighted
                      ? AppColors.blackColor
                      : AppColors.whiteColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isCurrent ? 'Current Plan' : 'Choose Plan'),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _benefits(PlanModel plan) {
    if (plan.benefits.isNotEmpty) return plan.benefits;
    return const [
      'Access to main gym area',
      'Basic fitness assessment',
      'Group classes per week',
      'Personal training sessions',
      'Nutrition consultation',
    ];
  }
}

class _CurrentPlanCard extends StatelessWidget {
  final SubscriptionModel? subscription;

  const _CurrentPlanCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    if (subscription == null) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF46F18C), AppColors.primaryColor],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        '${subscription!.plan.name}\n\$${subscription!.plan.price.toStringAsFixed(2)}/month',
        style: TextStyles.font16WhiteColorW600.copyWith(
          color: AppColors.blackColor,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: TextStyles.font10InterW400.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
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
