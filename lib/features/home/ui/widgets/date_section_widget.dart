import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final days = [18, 19, 20, 21, 22, 23, 24];
    final labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return SizedBox(
      height: 80,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < days.length; i++) ...[
              DayItem(
                number: days[i].toString(),
                short: labels[i],
                selected: i == 3,
              ),
              if (i != days.length - 1) horizontalSpace(2),
            ],
          ],
        ),
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
        color: selected ? AppColors.blackColor20 : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyles.font18whiteColorW600.copyWith(
              color: selected ? AppColors.primaryColor : Colors.white,
            ),
          ),
          horizontalSpace(2),
          Text(
            short,
            style: TextStyles.font13whiteColorW400.copyWith(
              color: selected
                  ? AppColors.primaryColor
                  : AppColors.greenColor5e6,
            ),
          ),
          verticalSpace(6),
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
