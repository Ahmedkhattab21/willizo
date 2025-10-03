import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final days = [18, 19, 20, 21, 22, 23, 24];
    final labels = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

    return SizedBox(
      height: 80.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < days.length; i++) ...[
            DayItem(
              number: days[i].toString(),
              short: labels[i],
              selected: i == 3,
            ),
            if (i != days.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class DayItem extends StatelessWidget {
  final String number;
  final String short;
  final bool selected;
  const DayItem({
    super.key,
    required this.number,
    required this.short,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: selected ? Color(0xff202600) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              color: selected ? AppColors.primaryColor : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            short,
            style: TextStyle(
              color: selected ? AppColors.primaryColor : Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
