import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class QuantityWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool canAdd;
  final bool canRemove;

  const QuantityWidget({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    this.canAdd = true,
    this.canRemove = true,
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
            child: InkWell(
              onTap: canRemove ? onRemove : null,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                bottomLeft: Radius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  "-",
                  style: TextStyle(
                    color: canRemove ? Colors.white : Colors.white38,
                    fontSize: 20,
                  ),
                ),
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
            child: InkWell(
              onTap: canAdd ? onAdd : null,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.r),
                bottomRight: Radius.circular(6.r),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: canAdd
                      ? AppColors.primaryColor
                      : AppColors.greyColorF2,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6.r),
                    bottomRight: Radius.circular(6.r),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "+",
                  style: TextStyle(
                    color: canAdd ? Colors.black : Colors.white54,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
