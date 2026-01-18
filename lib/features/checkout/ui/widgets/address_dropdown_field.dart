import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class AddressDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hintText;

  const AddressDropdownField({
    super.key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure value is in items list or set to null to avoid assertion error
    final validValue = value != null && items.contains(value) ? value : null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColorColor79),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: validValue,
          hint: Text(
            hintText ?? label,
            style: TextStyles.font14greyColorColor79W400,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: TextStyles.font14whiteColorColorW400),
            );
          }).toList(),
          onChanged: onChanged,
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
