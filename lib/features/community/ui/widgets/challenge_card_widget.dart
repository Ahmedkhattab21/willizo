import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final String participants;
  final String rank;
  final String icon;
  final Color startColor;
  final Color endColor;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.participants,
    required this.rank,
    required this.icon,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [startColor, endColor],
        ),
        boxShadow: [
          BoxShadow(
            color: endColor.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  icon,
                  height: 26.w,
                  width: 26.w,
                  color: Colors.white,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text("Active", style: TextStyles.font12InterW400),
                ),
              ],
            ),
            verticalSpace(18),
            Text(title, style: TextStyles.font16InterW600),
            verticalSpace(4),
            Text(
              "$participants participants",
              style: TextStyles.font12InterW400,
            ),
            verticalSpace(10),
            Text("Rank $rank", style: TextStyles.font12InterW400),
          ],
        ),
      ),
    );
  }
}
