import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/subscription/data/models/subscription_models.dart';
import 'package:willizo/features/subscription/data/repo/subscription_repo.dart';
import 'package:willizo/features/subscription/ui/change_plan_screen.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  final _emailController = TextEditingController();
  SubscriptionModel? _subscription;
  List<MemberModel> _members = const [];
  bool _loading = true;
  bool _sendingInvite = false;
  String? _error;

  SubscriptionRepo get _repo => getIt<SubscriptionRepo>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final subscriptionResult = await _repo.getCurrentSubscription();
    final membersResult = await _repo.getMembers();
    if (!mounted) return;

    subscriptionResult.fold((failure) {
      if (!_isNoActiveSubscription(failure.message)) {
        _error = failure.message;
      }
      _subscription = null;
    }, (response) => _subscription = response.subscription);
    membersResult.fold((failure) {
      if (!_isNoActiveSubscription(failure.message)) {
        _error ??= failure.message;
      }
      _members = const [];
    }, (response) => _members = response.members);

    setState(() => _loading = false);
  }

  Future<void> _sendInvitation() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || _sendingInvite) return;

    setState(() => _sendingInvite = true);
    final result = await _repo.inviteMember(email);
    if (!mounted) return;
    setState(() => _sendingInvite = false);
    result.fold(
      (failure) => AppConstant.toast(failure.message, AppColors.redColor),
      (message) {
        _emailController.clear();
        AppConstant.toast(message, AppColors.primaryColor);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            const _SubscriptionTopBar(),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: _load,
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : _error != null
                    ? _ErrorView(message: _error!, onRetry: _load)
                    : _subscription == null
                    ? _NoSubscriptionView(
                        onViewPlans: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangePlanScreen(),
                            ),
                          );
                          if (updated == true) _load();
                        },
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 32.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PlanCard(
                              subscription: _subscription,
                              membersCount: _members.length,
                            ),
                            verticalSpace(22),
                            _SectionTitle('Current Members'),
                            verticalSpace(12),
                            _MembersList(members: _members),
                            verticalSpace(24),
                            _SectionTitle('Add New Members'),
                            verticalSpace(12),
                            _InviteSection(
                              controller: _emailController,
                              isLoading: _sendingInvite,
                              onSend: _sendInvitation,
                            ),
                            verticalSpace(12),
                            _ShareInviteSection(),
                            verticalSpace(24),
                            _SectionTitle('Plan Settings'),
                            verticalSpace(8),
                            _SettingsList(
                              onBilling: () => Navigator.pushNamed(
                                context,
                                Routes.billingScreen,
                              ),
                              onPlanDetails: () => Navigator.pushNamed(
                                context,
                                Routes.planDetailsScreen,
                              ),
                              onChangePlan: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ChangePlanScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionTopBar extends StatelessWidget {
  const _SubscriptionTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      child: SizedBox(
        height: 44.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryColor,
                    size: 22.r,
                  ),
                ),
              ),
            ),
            Text(
              'Subscription',
              style: TextStyles.font20WhiteColorW600.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoSubscriptionView extends StatelessWidget {
  final VoidCallback onViewPlans;

  const _NoSubscriptionView({required this.onViewPlans});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 32.h),
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: AppColors.greyColor27,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.primaryColor),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.primaryColor,
                child: Icon(
                  Icons.workspace_premium,
                  color: AppColors.blackColor,
                ),
              ),
              verticalSpace(16),
              Text(
                'No active subscription',
                style: TextStyles.font16WhiteColorW600,
              ),
              verticalSpace(8),
              Text(
                'Choose one of the available plans to start your subscription.',
                textAlign: TextAlign.center,
                style: TextStyles.font12greyColorColor79W400,
              ),
              verticalSpace(18),
              _PrimaryButton(label: 'View Plans', onTap: onViewPlans),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionModel? subscription;
  final int membersCount;

  const _PlanCard({required this.subscription, required this.membersCount});

  @override
  Widget build(BuildContext context) {
    final plan = subscription?.plan;
    final maxMembers = subscription?.maxMembers ?? plan?.maxMembers ?? 0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF46F18C), AppColors.primaryColor],
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan?.name ?? 'Premium Family Plan',
                  style: TextStyles.font16WhiteColorW600.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
                verticalSpace(4),
                Text(
                  'Active since ${_formatDate(subscription?.activeSince)}',
                  style: TextStyles.font12InterWhiteW400.copyWith(
                    color: AppColors.blackColor.withValues(alpha: 0.75),
                  ),
                ),
                verticalSpace(14),
                Text(
                  '\$${(plan?.price ?? 0).toStringAsFixed(2)}/month',
                  style: TextStyles.font20WhiteColorW600.copyWith(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                verticalSpace(4),
                Text(
                  maxMembers > 0 ? 'Up to $maxMembers members' : 'Members',
                  style: TextStyles.font12InterWhiteW400.copyWith(
                    color: AppColors.blackColor.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.whiteColor.withValues(alpha: 0.75),
                child: Icon(Icons.groups, color: AppColors.blackColor),
              ),
              verticalSpace(16),
              Text(
                'Members',
                style: TextStyles.font10InterW400.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
              Text(
                '$membersCount/${maxMembers == 0 ? '-' : maxMembers}',
                style: TextStyles.font20WhiteColorW600.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MembersList extends StatelessWidget {
  final List<MemberModel> members;

  const _MembersList({required this.members});

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return Text(
        'No members yet',
        style: TextStyles.font14greyColorColor80W400,
      );
    }

    return Column(
      children: members
          .map(
            (member) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      Container(
                        width: 9.r,
                        height: 9.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: member.isOnline
                              ? AppColors.greenColor12
                              : AppColors.greyColor75,
                        ),
                      ),
                      horizontalSpace(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: TextStyles.font14WhiteColorW500,
                            ),
                            verticalSpace(3),
                            Text(
                              member.isOwner
                                  ? 'Plan Owner'
                                  : _memberSubtitle(member),
                              style: TextStyles.font12greyColorColor79W400,
                            ),
                          ],
                        ),
                      ),
                      if (member.isOwner)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            'Owner',
                            style: TextStyles.font10InterW400.copyWith(
                              color: AppColors.greenColorFA,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.person_remove_alt_1,
                          color: AppColors.greyColorCA,
                        ),
                    ],
                  ),
                ),
                Divider(color: AppColors.greyColor3d, height: 1),
              ],
            ),
          )
          .toList(),
    );
  }

  String _memberSubtitle(MemberModel member) {
    final date = _formatDate(member.lastActiveAt);
    return date == '-' ? member.email : 'Active $date';
  }
}

class _InviteSection extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const _InviteSection({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return _OutlinedPanel(
      icon: Icons.email_outlined,
      title: 'Send Invitation',
      child: Column(
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: TextStyles.font14whiteColorColorW400,
            decoration: _inputDecoration('Enter email address', Icons.person),
          ),
          verticalSpace(10),
          _PrimaryButton(
            label: 'Send Invitation',
            isLoading: isLoading,
            onTap: onSend,
          ),
        ],
      ),
    );
  }
}

class _ShareInviteSection extends StatelessWidget {
  final String inviteLink = 'https://willizo.com/invite';

  @override
  Widget build(BuildContext context) {
    return _OutlinedPanel(
      icon: Icons.reply_rounded,
      title: 'Share Invitation Link',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share this link with family or friends:',
            style: TextStyles.font12greyColorColor79W400,
          ),
          verticalSpace(10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    inviteLink,
                    style: TextStyles.font12InterWhiteW400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: inviteLink));
                    AppConstant.toast('Link copied', AppColors.primaryColor);
                  },
                  child: Icon(
                    Icons.copy,
                    color: AppColors.primaryColor,
                    size: 18.r,
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(10),
          _PrimaryButton(
            label: 'Share',
            icon: Icons.reply_rounded,
            onTap: () => Share.share(inviteLink),
          ),
        ],
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  final VoidCallback onBilling;
  final VoidCallback onPlanDetails;
  final VoidCallback onChangePlan;

  const _SettingsList({
    required this.onBilling,
    required this.onPlanDetails,
    required this.onChangePlan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingRow(
          icon: Icons.notifications,
          label: 'Notifications',
          onTap: () {},
        ),
        _SettingRow(
          icon: Icons.credit_card,
          label: 'Billing',
          onTap: onBilling,
        ),
        _SettingRow(
          icon: Icons.sync,
          label: 'Change Plan',
          onTap: onChangePlan,
        ),
        _SettingRow(
          icon: Icons.info_outline,
          label: 'Plan Details',
          onTap: onPlanDetails,
        ),
        _SettingRow(
          icon: Icons.help_outline,
          label: 'FAQ',
          onTap: () =>
              AppConstant.toast('FAQ coming soon', AppColors.primaryColor),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.greyColor3d, width: 0.8),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.greyColor75, size: 18.r),
            horizontalSpace(12),
            Expanded(
              child: Text(label, style: TextStyles.font14WhiteColorW500),
            ),
            Icon(Icons.chevron_right, color: AppColors.greyColor75),
          ],
        ),
      ),
    );
  }
}

class _OutlinedPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _OutlinedPanel({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF172000),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 18.r),
              horizontalSpace(8),
              Text(title, style: TextStyles.font14WhiteColorW500),
            ],
          ),
          verticalSpace(12),
          child,
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onTap,
        icon: isLoading
            ? SizedBox(
                width: 16.r,
                height: 16.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.blackColor,
                ),
              )
            : Icon(icon ?? Icons.send, size: 16.r),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.blackColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          textStyle: TextStyles.font14BlackColorW700,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyles.font16WhiteColorW600);
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.font14whiteColorColorW400,
            ),
            verticalSpace(12),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint, IconData icon) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyles.font12greyColorColor79W400,
    prefixIcon: Icon(icon, color: AppColors.greyColor75, size: 18.r),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
  );
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

bool _isNoActiveSubscription(String message) {
  final normalized = message.toLowerCase();
  return normalized.contains('no active subscription') ||
      normalized.contains('not subscribed') ||
      normalized.contains('subscription not found');
}
