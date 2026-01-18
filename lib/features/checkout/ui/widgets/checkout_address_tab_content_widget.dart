import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/checkout/data/models/address_model.dart';
import 'package:willizo/features/checkout/data/models/create_address_request_model.dart';
import 'package:willizo/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:willizo/features/checkout/ui/widgets/add_address_form.dart';
import 'package:willizo/features/checkout/ui/widgets/address_card.dart';

class CheckoutAddressTabContent extends StatefulWidget {
  final Function(String)? onContinueToNextStep;

  const CheckoutAddressTabContent({super.key, this.onContinueToNextStep});

  @override
  State<CheckoutAddressTabContent> createState() =>
      _CheckoutAddressTabContentState();
}

class _CheckoutAddressTabContentState extends State<CheckoutAddressTabContent> {
  bool _showAddForm = false;
  String _addressType = 'Home';
  String? _selectedCountry;
  String? _selectedDistrict;
  String? _selectedGovernorate;
  String? _selectedAddressId;
  AddressModel? selectedAddress;
  List<AddressModel> _lastLoadedAddresses = [];

  // Text controllers for form fields
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorApartmentController =
      TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityAreaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
    // Fetch addresses only if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CheckoutCubit>();
      final currentState = cubit.state;
      // Only fetch if addresses haven't been loaded yet
      if (currentState is! CheckoutAddressesLoaded) {
        cubit.getAddresses();
      } else {
        // Update local cache with existing addresses
        _lastLoadedAddresses = currentState.addresses;
      }
    });
  }

  Future<void> _loadPhoneNumber() async {
    final phone = await CacheHelper.getSecuredString(
      ConstantKeys.savePhoneToShared,
    );
    if (phone != null && phone.isNotEmpty) {
      _phoneController.text = phone;
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _buildingController.dispose();
    _floorApartmentController.dispose();
    _landmarkController.dispose();
    _cityAreaController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFieldsFromAddress(AddressModel address) {
    setState(() {
      selectedAddress = address;
      _selectedAddressId = address.id;
      _selectedCountry = address.country;
      _selectedGovernorate = address.governorate;
      _selectedDistrict = address.district;
      _addressType = address.type == 'home' ? 'Home' : 'Office';

      _streetController.text = address.street;
      _buildingController.text = address.building ?? '';
      _floorApartmentController.text = address.floorApartment ?? '';
      _landmarkController.text = address.landmark ?? '';
      _cityAreaController.text = address.area != null
          ? '${address.city} (${address.area})'
          : address.city;
      _phoneController.text = address.phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pin your location Header with Plus Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: AppColors.blackColor,
                    size: 24.sp,
                  ),
                ),
                horizontalSpace(12),
                Text(
                  "Pin your location",
                  style: TextStyles.font18WhiteColor700.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showAddForm = !_showAddForm;
                  if (!_showAddForm) {
                    // Clear form when closing
                    _clearForm();
                  }
                });
              },
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  _showAddForm ? Icons.close : Icons.add,
                  color: AppColors.blackColor,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),
        verticalSpace(24),

        // Show address cards or form based on state
        if (_showAddForm)
          BlocListener<CheckoutCubit, CheckoutState>(
            listener: (context, state) {
              if (state is CheckoutAddressCreated) {
                // Address created successfully, hide form and show address list
                setState(() {
                  _showAddForm = false;
                  _clearForm();
                });
                // Select the newly created address
                _selectedAddressId = state.address.id;
                selectedAddress = state.address;
              } else if (state is CheckoutError) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: AddAddressForm(
              selectedCountry: _selectedCountry,
              selectedDistrict: _selectedDistrict,
              selectedGovernorate: _selectedGovernorate,
              addressType: _addressType,
              selectedAddress: selectedAddress,
              streetController: _streetController,
              buildingController: _buildingController,
              floorApartmentController: _floorApartmentController,
              landmarkController: _landmarkController,
              cityAreaController: _cityAreaController,
              phoneController: _phoneController,
              onCountryChanged: (val) => setState(() => _selectedCountry = val),
              onDistrictChanged: (val) =>
                  setState(() => _selectedDistrict = val),
              onGovernorateChanged: (val) =>
                  setState(() => _selectedGovernorate = val),
              onAddressTypeChanged: (type) =>
                  setState(() => _addressType = type),
              onPopulateFields: _populateFieldsFromAddress,
              onAddAddress: _createAddress,
            ),
          )
        else
          _buildAddressCardsList(),
      ],
    );
  }

  void _clearForm() {
    _streetController.clear();
    _buildingController.clear();
    _floorApartmentController.clear();
    _landmarkController.clear();
    _cityAreaController.clear();
    _phoneController.clear();
    setState(() {
      _selectedCountry = null;
      _selectedDistrict = null;
      _selectedGovernorate = null;
      _addressType = 'Home';
      selectedAddress = null;
    });
    // Reload phone number when clearing form
    _loadPhoneNumber();
  }

  void _createAddress() {
    // Validate required fields
    if (_selectedCountry == null || _selectedCountry!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a country'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_streetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter street name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_cityAreaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter city/area'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Parse city and area from cityAreaController
    // Format: "City (Area)" or just "City"
    String city = _cityAreaController.text;
    String? area;
    if (_cityAreaController.text.contains('(') &&
        _cityAreaController.text.contains(')')) {
      final parts = _cityAreaController.text.split('(');
      city = parts[0].trim();
      area = parts[1].replaceAll(')', '').trim();
    }

    // Create request model
    final request = CreateAddressRequestModel(
      type: _addressType.toLowerCase(),
      country: _selectedCountry!,
      street: _streetController.text,
      building: _buildingController.text.isEmpty
          ? null
          : _buildingController.text,
      floorApartment: _floorApartmentController.text.isEmpty
          ? null
          : _floorApartmentController.text,
      landmark: _landmarkController.text.isEmpty
          ? null
          : _landmarkController.text,
      city: city,
      area: area,
      district: _selectedDistrict,
      governorate: _selectedGovernorate,
      phone: _phoneController.text,
      isDefault: false, // You can add a checkbox for this later
    );

    // Call cubit to create address
    context.read<CheckoutCubit>().createAddress(request);
  }

  Widget _buildAddressCardsList() {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        // Update last loaded addresses when we get new ones
        if (state is CheckoutAddressesLoaded) {
          _lastLoadedAddresses = state.addresses;
        }

        // Show loading only if we don't have any addresses yet
        if (state is CheckoutLoading && _lastLoadedAddresses.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }

        // Show error only if we don't have addresses to fall back to
        if (state is CheckoutError && _lastLoadedAddresses.isEmpty) {
          return Container(
            padding: EdgeInsets.all(20.w),
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

        // Use last loaded addresses (either from current state or cached)
        final addresses = state is CheckoutAddressesLoaded
            ? state.addresses
            : _lastLoadedAddresses;

        if (addresses.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(
                'No addresses found. Tap + to add one.',
                style: TextStyles.font14greyColorColor79W400,
              ),
            ),
          );
        }

        return Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              separatorBuilder: (context, index) => verticalSpace(12),
              itemBuilder: (context, index) {
                final address = addresses[index];
                return AddressCard(
                  address: address,
                  isSelected: _selectedAddressId == address.id,
                  onTap: () {
                    setState(() {
                      _selectedAddressId = address.id;
                      selectedAddress = address;
                    });
                  },
                );
              },
            ),
            if (_selectedAddressId != null) ...[
              verticalSpace(24),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Move to Information step with selected address ID
                    if (_selectedAddressId != null) {
                      widget.onContinueToNextStep?.call(_selectedAddressId!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
