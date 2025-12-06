import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class QuantityWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const QuantityWidget({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      width: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF111208),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyColorF2, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                "-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),

          Container(width: 2, color: AppColors.greyColorF2),

          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                "$quantity",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),

          Container(width: 1, color: Colors.grey.shade700),

          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6.r),
                  bottomRight: Radius.circular(6.r),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "+",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
