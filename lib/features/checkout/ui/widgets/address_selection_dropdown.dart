import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/checkout/data/models/address_model.dart';

class AddressSelectionDropdown extends StatelessWidget {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;
  final Function(AddressModel) onAddressSelected;

  const AddressSelectionDropdown({
    super.key,
    required this.addresses,
    this.selectedAddress,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColorColor79),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AddressModel>(
          value: selectedAddress,
          hint: Text(
            "Select Address",
            style: TextStyles.font14greyColorColor79W400,
          ),
          items: addresses.map((AddressModel address) {
            // Show city + governorate for better identification
            final displayText = address.governorate != null
                ? '${address.city}, ${address.governorate}'
                : address.city;
            return DropdownMenuItem<AddressModel>(
              value: address,
              child: Text(
                displayText,
                style: TextStyles.font14whiteColorColorW400,
              ),
            );
          }).toList(),
          onChanged: (AddressModel? address) {
            if (address != null) {
              onAddressSelected(address);
            }
          },
          dropdownColor: const Color(0xFF1E1E1E),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.greyColorColor79,
          ),
          isExpanded: true,
        ),
      ),
    );
  }
}
