import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class CheckListWidget extends StatelessWidget {
  final List<String> items;

  const CheckListWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((text) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check, color: Colors.green, size: 20),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyles.font14InterW400.copyWith(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
