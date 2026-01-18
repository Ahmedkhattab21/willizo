import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';
import 'package:willizo/features/checkout/ui/widgets/checkout_step_content.dart';
import 'package:willizo/features/checkout/ui/widgets/step_label.dart';

class CheckoutStepperWidget extends StatefulWidget {
  final Function(int)? onStepChanged;
  final List<CartItem> cartItems;

  const CheckoutStepperWidget({
    super.key,
    this.onStepChanged,
    this.cartItems = const [],
  });

  @override
  State<CheckoutStepperWidget> createState() => _CheckoutStepperWidgetState();
}

class _CheckoutStepperWidgetState extends State<CheckoutStepperWidget> {
  int _currentStep = 0;
  String? _selectedAddressId;

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
    widget.onStepChanged?.call(step);
  }

  void _onAddressSelected(String addressId) {
    setState(() {
      _selectedAddressId = addressId;
      _currentStep = 1;
    });
    widget.onStepChanged?.call(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40.w,
              height: 40.h,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.primaryColor, width: 1.5),
              ),
              child: SvgPicture.asset(ImageAsset.arrowBackIcon),
            ),
          ),
          verticalSpace(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StepLabel(
                title: "Address",
                isActive: _currentStep == 0,
                isCompleted: _currentStep > 0,
                onTap: () => _onStepTapped(0),
              ),
              StepLabel(
                title: "Information",
                isActive: _currentStep == 1,
                isCompleted: _currentStep > 1,
                onTap: () => _onStepTapped(1),
              ),
              StepLabel(
                title: "Payment",
                isActive: _currentStep == 2,
                isCompleted: _currentStep > 2,
                onTap: () => _onStepTapped(2),
              ),
              StepLabel(
                title: "Confirmation",
                isActive: _currentStep == 3,
                isCompleted: _currentStep > 3,
                onTap: () => _onStepTapped(3),
              ),
            ],
          ),
          verticalSpace(8),
          Stack(
            children: [
              // Background Line
              Container(
                width: double.infinity,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.greyColorColor79.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Active Line
              LayoutBuilder(
                builder: (context, constraints) {
                  double widthFactor;
                  switch (_currentStep) {
                    case 0:
                      widthFactor = 0.15;
                      break;
                    case 1:
                      widthFactor = 0.40;
                      break;
                    case 2:
                      widthFactor = 0.68;
                      break;
                    case 3:
                      widthFactor = 1.0;
                      break;
                    default:
                      widthFactor = 0.15;
                  }
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: constraints.maxWidth * widthFactor,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  );
                },
              ),
            ],
          ),
          verticalSpace(20),
          CheckoutStepContent(
            currentStep: _currentStep,
            cartItems: widget.cartItems,
            onStepTapped: _onStepTapped,
            selectedAddressId: _selectedAddressId,
            onAddressSelected: _onAddressSelected,
          ),
        ],
      ),
    );
  }
}
