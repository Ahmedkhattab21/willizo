import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/account/data/models/account_resonse.dart';
import 'package:willizo/features/account/data/models/update_profile_request_model.dart';
import 'package:willizo/features/account/logic/cubit/account_cubit.dart';
import 'package:willizo/features/account/ui/widgets/profile_header_widget.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key, this.accountData});

  final AccountData? accountData;

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    final data = widget.accountData;
    _nameController = TextEditingController(text: data?.name ?? '');
    _phoneController = TextEditingController(text: data?.phoneNumber ?? '');
    _emailController = TextEditingController(text: data?.email ?? '');
    _birthDateController = TextEditingController(
      text: data?.formattedDateOfBirth ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: BlocConsumer<AccountCubit, AccountState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccessState) {
              AppConstant.toast(
                'Profile updated successfully',
                AppColors.primaryColor,
              );
              Navigator.pop(context, true);
            } else if (state is UpdateProfileErrorState) {
              AppConstant.toast(state.message, AppColors.redColor);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 32.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _Header(),
                    verticalSpace(34),
                    ProfileHeader(
                      name: widget.accountData?.name ?? '',
                      email: widget.accountData?.email ?? '',
                    ),
                    verticalSpace(34),
                    _InfoField(
                      label: 'Full Name',
                      icon: Icons.person,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter full name';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(18),
                    _InfoField(
                      label: 'Phone Number',
                      icon: Icons.phone,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter phone number';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(18),
                    _InfoField(
                      label: 'Email Address',
                      icon: Icons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter email address';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Enter valid email address';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(18),
                    _InfoField(
                      label: 'Date of Birth',
                      icon: Icons.calendar_month,
                      controller: _birthDateController,
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      onTap: _pickBirthDate,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter date of birth';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(36),
                    ButtonWidget(
                      isLoading: state is UpdateProfileLoadingState,
                      borderRadius: 14,
                      buttonHeight: 50.h,
                      buttonText: 'Save',
                      backGroundColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      textStyle: TextStyles.font18blackColorW600,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AccountCubit>().updateProfile(
                            UpdateProfileRequestModel(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              phoneNumber: _phoneController.text.trim(),
                              dateOfBirth: _birthDateController.text.trim(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    final initialDate =
        DateTime.tryParse(_birthDateController.text) ??
        DateTime.now().subtract(const Duration(days: 365 * 18));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.blackColor,
              surface: AppColors.blackColor,
              onSurface: AppColors.whiteColor,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      _birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primaryColor,
              size: 20.r,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Personal Info',
            textAlign: TextAlign.center,
            style: TextStyles.font24WhiteColorW700,
          ),
        ),
        SizedBox(width: 34.r),
      ],
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      cursorColor: AppColors.primaryColor,
      style: TextStyles.font14whiteColorColorW400,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyles.font14greyColorColor79W400.copyWith(
          color: AppColors.greyColorColorA0,
        ),
        floatingLabelStyle: TextStyles.font14greyColorColor79W400.copyWith(
          color: AppColors.greyColorColorA0,
        ),
        prefixIcon: Icon(icon, color: AppColors.primaryColor, size: 20.r),
        filled: true,
        fillColor: AppColors.blackColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        enabledBorder: _border(AppColors.primaryColor),
        focusedBorder: _border(AppColors.primaryColor),
        errorBorder: _border(AppColors.redColor),
        focusedErrorBorder: _border(AppColors.redColor),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.8),
      borderRadius: BorderRadius.circular(10.r),
    );
  }
}
