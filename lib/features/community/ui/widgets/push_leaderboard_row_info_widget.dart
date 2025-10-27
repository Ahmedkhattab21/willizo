import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';

class PushupLeaderBoardRowInf extends StatelessWidget {
  final int rank;
  final String name;
  final String image;
  final String reps;
  final String diff;
  final bool highlight;
  final Color? medalColor;

  const PushupLeaderBoardRowInf({
    super.key,
    required this.rank,
    required this.name,
    required this.image,
    required this.reps,
    required this.diff,
    this.highlight = false,
    this.medalColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: highlight ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 34.w,
              width: 34.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: medalColor ?? Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ),
            horizontalSpace(12),
            ClipOval(
              child: Image.network(
                image,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: highlight ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "$reps reps",
                    style: TextStyle(
                      color: highlight
                          ? AppColors.greyColorColor80
                          : Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  reps,
                  style: TextStyle(
                    color: highlight ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  diff,
                  style: const TextStyle(
                    color: AppColors.greenColor4A,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
