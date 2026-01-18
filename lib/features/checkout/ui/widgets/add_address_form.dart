import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/checkout/data/models/address_model.dart';
import 'package:willizo/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:willizo/features/checkout/ui/widgets/address_dropdown_field.dart';
import 'package:willizo/features/checkout/ui/widgets/address_selection_dropdown.dart';
import 'package:willizo/features/checkout/ui/widgets/address_text_field.dart';
import 'package:willizo/features/checkout/ui/widgets/address_type_button.dart';

class AddAddressForm extends StatelessWidget {
  final String? selectedCountry;
  final String? selectedDistrict;
  final String? selectedGovernorate;
  final String addressType;
  final AddressModel? selectedAddress;
  final TextEditingController streetController;
  final TextEditingController buildingController;
  final TextEditingController floorApartmentController;
  final TextEditingController landmarkController;
  final TextEditingController cityAreaController;
  final TextEditingController phoneController;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onDistrictChanged;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String> onAddressTypeChanged;
  final Function(AddressModel) onPopulateFields;
  final VoidCallback onAddAddress;

  const AddAddressForm({
    super.key,
    required this.selectedCountry,
    required this.selectedDistrict,
    required this.selectedGovernorate,
    required this.addressType,
    this.selectedAddress,
    required this.streetController,
    required this.buildingController,
    required this.floorApartmentController,
    required this.landmarkController,
    required this.cityAreaController,
    required this.phoneController,
    required this.onCountryChanged,
    required this.onDistrictChanged,
    required this.onGovernorateChanged,
    required this.onAddressTypeChanged,
    required this.onPopulateFields,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country Dropdown
        BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            // Common countries as fallback
            const commonCountries = ["Egypt", "Saudi Arabia", "UAE", "US"];
            final Set<String> countriesSet = <String>{};
            
            // Add common countries first
            countriesSet.addAll(commonCountries);
            
            if (state is CheckoutAddressesLoaded) {
              // Extract unique countries from addresses
              for (final addr in state.addresses) {
                if (addr.country.isNotEmpty) {
                  countriesSet.add(addr.country);
                }
              }
            }
            
            // If selected country is not in the set, add it
            if (selectedCountry != null && selectedCountry!.isNotEmpty) {
              countriesSet.add(selectedCountry!);
            }
            
            // Convert to sorted list for better UX
            final List<String> countries = countriesSet.toList()..sort();
            
            // Ensure selectedCountry value is valid (either in items or null)
            final validValue = countries.contains(selectedCountry) 
                ? selectedCountry 
                : null;
            
            return AddressDropdownField(
              label: "Country",
              value: validValue,
              items: countries,
              onChanged: onCountryChanged,
            );
          },
        ),
        verticalSpace(16),

        // Street Name
        AddressTextField(
          label: "Street name",
          hintText: "Street name",
          controller: streetController,
        ),
        verticalSpace(16),

        // Building Name/No
        AddressTextField(
          label: "Building name/no",
          hintText: "Building name/no",
          controller: buildingController,
        ),
        verticalSpace(16),

        // Floor/Apartment and Landmark Row
        Row(
          children: [
            Expanded(
              child: AddressTextField(
                label: "Floor/Apartment",
                hintText: "Floor/Apartment",
                controller: floorApartmentController,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: AddressTextField(
                label: "Landmark (optional)",
                hintText: "Landmark (optional)",
                controller: landmarkController,
              ),
            ),
          ],
        ),
        verticalSpace(16),

        // City/Area
        AddressTextField(
          label: "City/Area",
          hintText: "City/Area (El Nozha & New Cairo City)",
          controller: cityAreaController,
        ),
        verticalSpace(16),

        // Address Dropdown (showing city + governorate)
        BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutAddressesLoaded) {
              return AddressSelectionDropdown(
                addresses: state.addresses,
                selectedAddress: selectedAddress,
                onAddressSelected: onPopulateFields,
              );
            } else if (state is CheckoutLoading) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.greyColorColor79),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              );
            } else if (state is CheckoutError) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.greyColorColor79),
                ),
                child: Text(
                  'Error: ${state.message}',
                  style: TextStyles.font14whiteColorColorW400,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        verticalSpace(16),

        // District Dropdown
        BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            final Set<String> districtsSet = <String>{};
            const fallbackDistricts = ["District 1", "District 2"];
            
            if (state is CheckoutAddressesLoaded) {
              // Extract unique districts from addresses
              for (final addr in state.addresses) {
                if (addr.district != null && addr.district!.isNotEmpty) {
                  districtsSet.add(addr.district!);
                }
              }
            }
            
            // Add fallback districts if empty
            if (districtsSet.isEmpty) {
              districtsSet.addAll(fallbackDistricts);
            }
            
            // If selected district is not in the set, add it
            if (selectedDistrict != null && selectedDistrict!.isNotEmpty) {
              districtsSet.add(selectedDistrict!);
            }
            
            final List<String> districts = districtsSet.toList()..sort();
            
            return AddressDropdownField(
              label: "District",
              value: selectedDistrict,
              items: districts,
              onChanged: onDistrictChanged,
              hintText: "District",
            );
          },
        ),
        verticalSpace(16),

        // Governorate Dropdown
        BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            final Set<String> governoratesSet = <String>{};
            const fallbackGovernorates = ["Cairo", "Giza", "Alexandria"];
            
            // Add fallback governorates first
            governoratesSet.addAll(fallbackGovernorates);
            
            if (state is CheckoutAddressesLoaded) {
              // Extract unique governorates from addresses
              for (final addr in state.addresses) {
                if (addr.governorate != null && addr.governorate!.isNotEmpty) {
                  governoratesSet.add(addr.governorate!);
                }
              }
            }
            
            // If selected governorate is not in the set, add it
            if (selectedGovernorate != null && selectedGovernorate!.isNotEmpty) {
              governoratesSet.add(selectedGovernorate!);
            }
            
            final List<String> governorates = governoratesSet.toList()..sort();
            
            return AddressDropdownField(
              label: "Governorate",
              value: selectedGovernorate,
              items: governorates,
              onChanged: onGovernorateChanged,
              hintText: "Governorate",
            );
          },
        ),
        verticalSpace(16),

        // Phone Number
        AddressTextField(
          label: "Phone Number",
          hintText: "Phone Number",
          controller: phoneController,
        ),
        verticalSpace(24),

        // Address Type
        Text(
          "Address Type",
          style: TextStyles.font14whiteColorColorW400.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        verticalSpace(12),
        Row(
          children: [
            AddressTypeButton(
              type: "Home",
              isSelected: addressType == "Home",
              onTap: () => onAddressTypeChanged("Home"),
            ),
            horizontalSpace(12),
            AddressTypeButton(
              type: "Office",
              isSelected: addressType == "Office",
              onTap: () => onAddressTypeChanged("Office"),
            ),
          ],
        ),
        verticalSpace(32),

        // Add address Button
        SizedBox(
          width: double.infinity,
          height: 54.h,
          child: ElevatedButton(
            onPressed: onAddAddress,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              "Add address",
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        verticalSpace(20),
      ],
    );
  }
}
