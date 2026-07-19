import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_response_model.dart';
import 'package:willizo/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_address_tab_content_widget.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_confirmation_tab_content.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_information_tab_content.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_payment_tab_content.dart';

class CheckoutStepContent extends StatelessWidget {
  final int currentStep;
  final List<CartItem> cartItems;
  final ValueChanged<int> onStepTapped;
  final ValueChanged<String>? onOrderConfirmed;
  final String? selectedAddressId;
  final Function(String)? onAddressSelected;
  final String? confirmedOrderId;

  const CheckoutStepContent({
    super.key,
    required this.currentStep,
    required this.cartItems,
    required this.onStepTapped,
    this.onOrderConfirmed,
    this.selectedAddressId,
    this.onAddressSelected,
    this.confirmedOrderId,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return CheckoutAddressTabContent(
          onContinueToNextStep: (addressId) {
            // Store address ID and move to next step
            onAddressSelected?.call(addressId);
          },
        );
      case 1:
        return CheckoutInformationTabContent(
          cartItems: cartItems,
          addressId: selectedAddressId,
          onContinueToPayment: () => onStepTapped(2),
        );
      case 2:
        return BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            CheckoutCalculationResponseModel? calculation;
            if (state is CheckoutCalculationLoaded) {
              calculation = state.calculation;
            }
            return CheckoutPaymentTabContent(
              calculation: calculation,
              onOrderConfirmed: onOrderConfirmed,
            );
          },
        );
      case 3:
        return CheckoutConfirmationTabContent(orderId: confirmedOrderId);
      default:
        return const SizedBox.shrink();
    }
  }
}
