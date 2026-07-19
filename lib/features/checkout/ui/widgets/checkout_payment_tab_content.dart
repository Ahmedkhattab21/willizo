import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_response_model.dart';
import 'package:willizo/features/checkout/logic/cubit/checkout_cubit.dart';

class CheckoutPaymentTabContent extends StatefulWidget {
  final CheckoutCalculationResponseModel? calculation;
  final ValueChanged<String>? onOrderConfirmed;

  const CheckoutPaymentTabContent({
    super.key,
    this.calculation,
    this.onOrderConfirmed,
  });

  @override
  State<CheckoutPaymentTabContent> createState() =>
      _CheckoutPaymentTabContentState();
}

class _CheckoutPaymentTabContentState extends State<CheckoutPaymentTabContent> {
  bool _isProcessing = false;
  bool _hasStartedCheckout = false;
  String? _confirmedOrderId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCheckout();
    });
  }

  void _startCheckout() {
    if (_isProcessing || _hasStartedCheckout) return;

    setState(() {
      _hasStartedCheckout = true;
      _isProcessing = true;
    });

    context.read<CheckoutCubit>().confirmCheckout();
  }

  Future<void> _openPaymentWebView(String checkoutUrl) async {
    final paid = await context.pushNamed(
      Routes.checkoutPaymentWebViewScreen,
      arguments: {'checkoutUrl': checkoutUrl},
    );

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    if (paid == true) {
      widget.onOrderConfirmed?.call(_confirmedOrderId ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutOrderConfirmed) {
          final checkoutUrl = state.orderResponse.checkoutUrl;
          _confirmedOrderId = state.orderResponse.order.id;
          if (state.orderResponse.paymentRequired && checkoutUrl.isNotEmpty) {
            _openPaymentWebView(checkoutUrl);
          } else {
            setState(() {
              _isProcessing = false;
            });
            widget.onOrderConfirmed?.call(_confirmedOrderId ?? '');
          }
        } else if (state is CheckoutError) {
          setState(() {
            _hasStartedCheckout = false;
            _isProcessing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: _buildLoadingContent(),
    );
  }

  Widget _buildLoadingContent() {
    return SizedBox(
      height: 420.h,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 44.w,
              height: 44.w,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'Opening payment...',
              style: TextStyles.font16WhiteColorW600.copyWith(
                fontSize: 16.sp,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
