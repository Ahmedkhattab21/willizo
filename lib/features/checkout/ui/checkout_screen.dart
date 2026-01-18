import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';
import 'package:willizo/features/checkout/data/repos/checkout_repo.dart';
import 'package:willizo/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_stepper_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({super.key, this.cartItems = const []});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;

  void _onStepChanged(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit(getIt<CheckoutRepo>())..getAddresses(),
      child: Scaffold(
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
                    CheckoutStepperWidget(
                      onStepChanged: _onStepChanged,
                      cartItems: widget.cartItems,
                    ),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
