import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/cart/ui/widgets/trust_badges_widget.dart';

class CartStepperWidget extends StatefulWidget {
  final Function(int)? onStepChanged;

  const CartStepperWidget({super.key, this.onStepChanged});

  @override
  State<CartStepperWidget> createState() => _CartStepperWidgetState();
}

class _CartStepperWidgetState extends State<CartStepperWidget> {
  int _currentStep = 0;

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
    // Notify parent widget about step change
    widget.onStepChanged?.call(step);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepLabel(
            title: "Information",
            isActive: _currentStep == 0,
            isCompleted: _currentStep > 0,
            onTap: () => _onStepTapped(0),
          ),
          _StepLabel(
            title: "Address",
            isActive: _currentStep == 1,
            isCompleted: _currentStep > 1,
            onTap: () => _onStepTapped(1),
          ),
          _StepLabel(
            title: "Payment",
            isActive: _currentStep == 2,
            isCompleted: _currentStep > 2,
            onTap: () => _onStepTapped(2),
          ),
          _StepLabel(
            title: "Confirmation",
            isActive: _currentStep == 3,
            isCompleted: _currentStep > 3,
            onTap: () => _onStepTapped(3),
          ),
          verticalSpace(8),
          Stack(
            children: [
              // Background Line
              Container(
                width: double.infinity,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.greyColorColor79.withOpacity(0.3),
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
                      widthFactor = 0.42;
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
          // Content based on current step
          _buildStepContent(),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return const InformationTabContent();
      case 1:
        return const AddressTabContent();
      case 2:
        return const PaymentTabContent();
      case 3:
        return const ConfirmationTabContent();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _StepLabel extends StatelessWidget {
  final String title;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback onTap;

  const _StepLabel({
    required this.title,
    required this.isActive,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: isActive
            ? TextStyles.font14primaryColorW600.copyWith(
                color: AppColors.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              )
            : TextStyles.font14GreyColorW400.copyWith(
                color: AppColors.greyColorColor79,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
      ),
    );
  }
}

// Information Tab Content Widget
class InformationTabContent extends StatelessWidget {
  const InformationTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Information Header
        Row(
          children: [
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "1",
                  style: TextStyles.font14W700.copyWith(
                    color: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            horizontalSpace(12),
            Text(
              "Personal Information",
              style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
            ),
          ],
        ),
        verticalSpace(20),
        // Full Name Field
        _buildInputField(
          icon: Icons.person,
          label: "Full Name",
          hintText: "Full Name",
        ),
        verticalSpace(16),
        // Email Address Field
        _buildInputField(
          icon: Icons.email,
          label: "Email Address",
          hintText: "Email Address",
        ),
        verticalSpace(16),
        // Phone Number Field
        _buildInputField(
          icon: Icons.phone,
          label: "Phone Number",
          hintText: "Phone Number",
        ),
        verticalSpace(12),
        // Edit Button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.edit, color: AppColors.primaryColor, size: 16.sp),
            label: Text(
              "Edit",
              style: TextStyles.font14primaryColorW600.copyWith(
                color: AppColors.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        verticalSpace(30),
        // Order Summary Section
        Text(
          "Order Summary",
          style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
        ),
        verticalSpace(16),
        _buildSummaryRow("Subtotal", "\$899.98"),
        verticalSpace(12),
        _buildSummaryRow("Discount", "-\$100.00", isDiscount: true),
        verticalSpace(12),
        _buildSummaryRow("Tax", "\$71.99"),
        verticalSpace(16),
        Divider(color: AppColors.greyColorColor79.withOpacity(0.3)),
        verticalSpace(16),
        _buildSummaryRow("Total", "\$871.97", isTotal: true),
        verticalSpace(30),
        // Continue to Payment Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Continue to Payment",
              style: TextStyles.font16WhiteColorW600.copyWith(
                color: AppColors.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        verticalSpace(30),
        // Trust Badges
        const TrustBadgesWidget(),
      ],
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
    required String hintText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryColor, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 20.sp),
          horizontalSpace(12),
          Expanded(
            child: Text(
              hintText,
              style: TextStyles.font14whiteColorColorW400.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? TextStyles.font16WhiteColorW600.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                )
              : TextStyles.font14GreyColorW400.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.greyColorColor79,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? TextStyles.font16WhiteColorW600.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                )
              : isDiscount
              ? TextStyles.font14whiteColorColorW400.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.greenColor7C,
                )
              : TextStyles.font14whiteColorColorW400.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}

class AddressTabContent extends StatefulWidget {
  const AddressTabContent({super.key});

  @override
  State<AddressTabContent> createState() => _AddressTabContentState();
}

class _AddressTabContentState extends State<AddressTabContent> {
  String _addressType = 'Home';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pin Location Header
        Row(
          children: [
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: AppColors.blackColor,
                size: 18.sp,
              ),
            ),
            horizontalSpace(12),
            Text(
              "Pin your location",
              style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
            ),
          ],
        ),
        verticalSpace(20),
        // Form Fields
        _buildDropdown("Egypt"),
        verticalSpace(16),
        _buildInputField("Street name"),
        verticalSpace(16),
        _buildInputField("Building name/no"),
        verticalSpace(16),
        Row(
          children: [
            Expanded(child: _buildInputField("Floor/Apartment")),
            horizontalSpace(12),
            Expanded(child: _buildInputField("Landmark (optional)")),
          ],
        ),
        verticalSpace(16),
        _buildInputField("City/Area (El Nozha & New Cairo City)"),
        verticalSpace(16),
        _buildDropdown("District"),
        verticalSpace(16),
        _buildDropdown("Governorate"),
        verticalSpace(24),
        // Address Type
        Text(
          "Address Type",
          style: TextStyles.font16WhiteColorW600.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        verticalSpace(12),
        Row(
          children: [
            _buildAddressTypeChip("Home"),
            horizontalSpace(12),
            _buildAddressTypeChip("Office"),
          ],
        ),
        verticalSpace(30),
        // Add Address Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Add address",
              style: TextStyles.font16WhiteColorW600.copyWith(
                color: AppColors.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        verticalSpace(30),
      ],
    );
  }

  Widget _buildInputField(String hintText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.greyColorColor79.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: Text(
        hintText,
        style: TextStyles.font14whiteColorColorW400.copyWith(
          fontSize: 14.sp,
          color: AppColors.greyColorColor79,
        ),
      ),
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.greyColorColor79.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyles.font14whiteColorColorW400.copyWith(
              fontSize: 14.sp,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.greyColorColor79,
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTypeChip(String type) {
    final isSelected = _addressType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _addressType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          type,
          style: TextStyles.font14W600.copyWith(
            fontSize: 14.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Payment Tab Content Widget
class PaymentTabContent extends StatefulWidget {
  const PaymentTabContent({super.key});

  @override
  State<PaymentTabContent> createState() => _PaymentTabContentState();
}

class _PaymentTabContentState extends State<PaymentTabContent> {
  String _selectedPaymentMethod = 'credit_card';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Payment Information Header
        Row(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "2",
                  style: TextStyles.font14W700.copyWith(
                    color: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            horizontalSpace(8),
            Text(
              "Payment Information",
              style: TextStyles.font18WhiteColor700.copyWith(fontSize: 18.sp),
            ),
          ],
        ),
        verticalSpace(20),
        // Payment Method Selection
        Row(
          children: [
            Expanded(
              child: _buildPaymentMethodButton(
                'credit_card',
                'Credit Card',
                Icons.credit_card,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: _buildPaymentMethodButton(
                'apple_pay',
                'Apple Pay',
                Icons.apple,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: _buildPaymentMethodButton(
                'paypal',
                'PayPal',
                Icons.payment,
              ),
            ),
          ],
        ),
        verticalSpace(20),
        // Payment Form Fields (shown only for credit card)
        if (_selectedPaymentMethod == 'credit_card') ...[
          _buildPaymentField(
            icon: Icons.credit_card,
            label: "Card Number",
            hintText: "1234 5678 9012 3456",
          ),
          verticalSpace(16),
          _buildPaymentField(
            icon: Icons.calendar_today,
            label: "Expiry Date",
            hintText: "MM/YY",
          ),
          verticalSpace(16),
          _buildPaymentField(
            icon: Icons.lock_outline,
            label: "CVV",
            hintText: "123",
          ),
          verticalSpace(16),
          _buildPaymentField(
            icon: Icons.person_outline,
            label: "Cardholder Name",
            hintText: "John Doe",
          ),
          verticalSpace(30),
        ],
        // Order Summary Section
        Text(
          "Order Summary",
          style: TextStyles.font18WhiteColor700.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        verticalSpace(16),
        _buildSummaryRow("Subtotal", "\$899.98"),
        verticalSpace(12),
        _buildSummaryRow("Discount", "-\$100.00", isDiscount: true),
        verticalSpace(12),
        _buildSummaryRow("Tax", "\$71.99"),
        verticalSpace(16),
        Divider(color: AppColors.greyColorColor79.withOpacity(0.3)),
        verticalSpace(16),
        _buildSummaryRow("Total", "\$871.97", isTotal: true),
        verticalSpace(30),
        // Complete Purchase Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            icon: Icon(
              Icons.shopping_bag,
              color: AppColors.blackColor,
              size: 20.sp,
            ),
            label: Text(
              "Complete Purchase",
              style: TextStyles.font16WhiteColorW600.copyWith(
                color: AppColors.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        verticalSpace(30),
        // Trust Badges
        const TrustBadgesWidget(),
      ],
    );
  }

  Widget _buildPaymentMethodButton(String method, String label, IconData icon) {
    final isSelected = _selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyColorColor79.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.blackColor
                  : AppColors.greyColorColor79,
              size: 18.sp,
            ),
            horizontalSpace(6),
            Flexible(
              child: Text(
                label,
                style: TextStyles.font14W600.copyWith(
                  color: isSelected
                      ? AppColors.blackColor
                      : AppColors.greyColorColor79,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentField({
    required IconData icon,
    required String label,
    required String hintText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryColor, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 20.sp),
          horizontalSpace(12),
          Expanded(
            child: Text(
              hintText,
              style: TextStyles.font14whiteColorColorW400.copyWith(
                fontSize: 14.sp,
                color: AppColors.greyColorColor79,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? TextStyles.font16WhiteColorW600.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                )
              : TextStyles.font14GreyColorW400.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.greyColorColor79,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? TextStyles.font16WhiteColorW600.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                )
              : isDiscount
              ? TextStyles.font14whiteColorColorW400.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.greenColor7C,
                )
              : TextStyles.font14whiteColorColorW400.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}

// Confirmation Tab Content Widget
class ConfirmationTabContent extends StatelessWidget {
  const ConfirmationTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        verticalSpace(20),
        SvgPicture.asset(ImageAsset.confirmationIcon),
        verticalSpace(24),
        Text(
          "Payment Successful!",
          style: TextStyles.font18WhiteColor700.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpace(12),
        // Success Message
        Text(
          "Thank you for your purchase. Your\nFitness journey starts now.",
          style: TextStyles.font14GreyColorW400.copyWith(
            fontSize: 14.sp,
            color: AppColors.greyColorColor79,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpace(40),
        // Order Summary Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.greyColorColor79.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.greyColorColor79.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order Summary",
                style: TextStyles.font18WhiteColor700.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              verticalSpace(20),
              _buildOrderDetailRow("Order Number", "FF-2024-18454"),
              verticalSpace(16),
              Divider(color: AppColors.greyColorColor79.withOpacity(0.3)),
              verticalSpace(16),
              _buildOrderDetailRow("Item", "T-shirt"),
              verticalSpace(16),
              Divider(color: AppColors.greyColorColor79.withOpacity(0.3)),
              verticalSpace(16),
              _buildOrderDetailRow("Amount Paid", "\$871.97", isAmount: true),
            ],
          ),
        ),
        // verticalSpace(30),
        // Next Steps Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.greyColorColor79.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.greyColorColor79.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Next Steps",
                style: TextStyles.font18WhiteColor700.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              verticalSpace(16),
              Text(
                "A confirmation email has been sent to your\naddress with details. Welcome to Willizo\nfamily!",
                style: TextStyles.font14GreyColorW400.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.greyColorColor79,
                ),
              ),
            ],
          ),
        ),
        verticalSpace(40),
        // Back To Homepage Button
        SizedBox(
          width: 189.w,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () {
              // Navigate back to homepage
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Back To Homepage",
              style: TextStyles.font16WhiteColorW600.copyWith(
                color: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        verticalSpace(40),
      ],
    );
  }

  Widget _buildOrderDetailRow(
    String label,
    String value, {
    bool isAmount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.font14GreyColorW400.copyWith(
            fontSize: 14.sp,
            color: AppColors.greyColorColor79,
          ),
        ),
        Text(
          value,
          style: isAmount
              ? TextStyles.font16WhiteColorW600.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                )
              : TextStyles.font14whiteColorColorW400.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}
