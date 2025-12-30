import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_stepper_widget.dart';
import 'package:willizo/features/product_details/ui/widgets/footer_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0; // 0 = Information, 1 = Address, 2 = Payment, 3 = Confirmation

  void _onStepChanged(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckoutStepperWidget(onStepChanged: _onStepChanged),
                  ],
                ),
              ),
              // Footer (hidden on Confirmation tab - step 3)
              if (_currentStep != 3)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const FooterWidget(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

