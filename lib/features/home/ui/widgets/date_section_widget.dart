import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/home/logic/cubit/home_cubit.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final weekDays = _currentWeekDays();

        return SizedBox(
          height: 80,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < weekDays.length; i++) ...[
                  DayItem(
                    number: weekDays[i].day.toString(),
                    short: _weekdayShort(weekDays[i].weekday),
                    selected: _isSameDay(weekDays[i], state.selectedDate),
                    onTap: () => context.read<HomeCubit>().selectDate(weekDays[i]),
                  ),
                  if (i != weekDays.length - 1) horizontalSpace(2),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  List<DateTime> _currentWeekDays() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    return List.generate(
      7,
      (i) => DateTime(
        firstDayOfWeek.year,
        firstDayOfWeek.month,
        firstDayOfWeek.day + i,
      ),
    );
  }

  String _weekdayShort(int weekday) {
    return switch (weekday) {
      DateTime.monday => 'Mo',
      DateTime.tuesday => 'Tu',
      DateTime.wednesday => 'We',
      DateTime.thursday => 'Th',
      DateTime.friday => 'Fr',
      DateTime.saturday => 'Sa',
      DateTime.sunday => 'Su',
      _ => '',
    };
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class DayItem extends StatelessWidget {
  final String number;
  final String short;
  final bool selected;
  final VoidCallback? onTap;
  const DayItem({
    super.key,
    required this.number,
    required this.short,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
      ),
    );
  }
}
