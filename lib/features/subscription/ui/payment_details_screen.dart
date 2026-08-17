import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/subscription/data/models/subscription_models.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final SubscriptionPaymentModel payment;

  const PaymentDetailsScreen({super.key, required this.payment});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  bool _sharing = false;

  Future<void> _shareReceipt() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    await Share.share(
      'Receipt #${widget.payment.transactionId}\n'
      'Plan: ${widget.payment.planName}\n'
      'Amount: \$${widget.payment.amount.toStringAsFixed(2)}',
    );
    if (!mounted) return;
    setState(() => _sharing = false);
  }

  @override
  Widget build(BuildContext context) {
    final payment = widget.payment;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        centerTitle: true,
        title: Text('Payment Details', style: TextStyles.font20WhiteColorW600),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 32.h),
        children: [
          _SuccessCard(payment: payment),
          verticalSpace(14),
          _DetailsCard(
            title: 'Transaction Details',
            rows: [
              _InfoRow('Transaction ID', payment.transactionId),
              _InfoRow('Date & Time', _formatDate(payment.date)),
              _InfoRow('Payment Method', payment.paymentMethod),
              _InfoRow('Status', payment.status),
            ],
          ),
          verticalSpace(14),
          _DetailsCard(
            title: 'Membership Information',
            rows: [
              _InfoRow('Plan Type', payment.planName),
              _InfoRow('Member ID', payment.id),
              _InfoRow('Valid Until', _formatDate(payment.date)),
            ],
          ),
          verticalSpace(14),
          _DetailsCard(
            title: 'Billing Breakdown',
            rows: [
              _InfoRow('Subtotal', '\$${payment.subtotal.toStringAsFixed(2)}'),
              _InfoRow(
                'Member Discount',
                '-\$${payment.discount.toStringAsFixed(2)}',
              ),
              _InfoRow('Tax', '\$${payment.tax.toStringAsFixed(2)}'),
              _InfoRow(
                'Total',
                '\$${payment.amount.toStringAsFixed(2)}',
                highlight: true,
              ),
            ],
          ),
          verticalSpace(14),
          _NextPaymentCard(amount: payment.amount),
          verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: _ReceiptButton(
                  label: 'Share Receipt',
                  icon: Icons.reply,
                  isFilled: false,
                  isLoading: _sharing,
                  onTap: _shareReceipt,
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: _ReceiptButton(
                  label: 'Download Receipt',
                  icon: Icons.download,
                  isFilled: true,
                  onTap: () => AppConstant.toast(
                    'Receipt download will open from API link',
                    AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final SubscriptionPaymentModel payment;

  const _SuccessCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 26.r,
            backgroundColor: AppColors.greenColorFA,
            child: Icon(Icons.check, color: AppColors.whiteColor),
          ),
          verticalSpace(14),
          Text('Payment Successful', style: TextStyles.font16WhiteColorW600),
          verticalSpace(6),
          Text(
            'Your gym membership has been renewed',
            style: TextStyles.font12greyColorColor79W400,
          ),
          verticalSpace(12),
          Text(
            '\$${payment.amount.toStringAsFixed(2)}',
            style: TextStyles.font24WhiteColorW700,
          ),
          Text(payment.planName, style: TextStyles.font12greyColorColor79W400),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;

  const _DetailsCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.font16WhiteColorW600),
          verticalSpace(12),
          ...rows,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _InfoRow(this.label, this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyles.font12greyColorColor79W400),
          ),
          Text(
            value.isEmpty ? '-' : value,
            textAlign: TextAlign.end,
            style: TextStyles.font12InterWhiteW400.copyWith(
              color: highlight ? AppColors.primaryColor : AppColors.whiteColor,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextPaymentCard extends StatelessWidget {
  final double amount;

  const _NextPaymentCard({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          Icon(Icons.calendar_month, color: AppColors.primaryColor),
          horizontalSpace(10),
          Expanded(
            child: Text(
              'Your next payment of \$${amount.toStringAsFixed(2)} will be charged automatically.',
              style: TextStyles.font12greyColorColor79W400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isFilled;
  final bool isLoading;
  final VoidCallback onTap;

  const _ReceiptButton({
    required this.label,
    required this.icon,
    required this.isFilled,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onTap,
        icon: isLoading
            ? SizedBox(
                width: 14.r,
                height: 14.r,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, size: 15.r),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isFilled
              ? AppColors.primaryColor
              : AppColors.blackColor,
          foregroundColor: isFilled
              ? AppColors.blackColor
              : AppColors.primaryColor,
          side: const BorderSide(color: AppColors.primaryColor),
          elevation: 0,
          textStyle: TextStyles.font10InterW400.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}

BoxDecoration _boxDecoration() {
  return BoxDecoration(
    color: const Color(0xFF172000),
    borderRadius: BorderRadius.circular(10.r),
    border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.7)),
  );
}

String _formatDate(String value) {
  if (value.isEmpty) return '-';
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
