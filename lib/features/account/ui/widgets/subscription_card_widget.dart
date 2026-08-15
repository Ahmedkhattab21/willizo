import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/subscription/data/models/subscription_models.dart';
import 'package:willizo/features/subscription/data/repo/subscription_repo.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SubscriptionModel?>(
      future: _loadSubscription(),
      builder: (context, snapshot) {
        final subscription = snapshot.data;
        return InkWell(
          onTap: () => Navigator.pushNamed(context, Routes.subscribeScreen),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: AppColors.greyColor27,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 18.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : _SubscriptionContent(subscription: subscription),
          ),
        );
      },
    );
  }

  Future<SubscriptionModel?> _loadSubscription() async {
    final result = await getIt<SubscriptionRepo>().getCurrentSubscription();
    return result.fold((_) => null, (response) => response.subscription);
  }
}

class _SubscriptionContent extends StatelessWidget {
  final SubscriptionModel? subscription;

  const _SubscriptionContent({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final plan = subscription?.plan;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan',
                    style: TextStyles.font14whiteColorColorW400.copyWith(
                      color: AppColors.greyColorColor80,
                    ),
                  ),
                  verticalSpace(8),
                  Text(
                    plan?.name ?? 'No active plan',
                    style: TextStyles.font16WhiteColorW600,
                  ),
                  verticalSpace(6),
                  Text(
                    'Next renewal: ${_formatDate(subscription?.nextBillingDate)}',
                    style: TextStyles.font12greyColorColor79W400.copyWith(
                      color: AppColors.greyColorColor80,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Text(
                (subscription?.status ?? 'INACTIVE').toUpperCase(),
                style: TextStyles.font14primaryColorW600,
              ),
            ),
          ],
        ),
        verticalSpace(20),
        Text(
          'Family',
          style: TextStyles.font14whiteColorColorW400.copyWith(
            color: AppColors.greyColorColor80,
          ),
        ),
        verticalSpace(8),
        Text(
          '${subscription?.membersCount ?? 0} members',
          style: TextStyles.font16WhiteColorW600,
        ),
      ],
    );
  }
}

String _formatDate(String? value) {
  if (value == null || value.isEmpty) return 'N/A';
  final date = DateTime.tryParse(value);
  if (date == null) return value.split('T').first;
  return date.toIso8601String().split('T').first;
}
