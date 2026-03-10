import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class LeagueListItemWidget extends StatelessWidget {
  final String title;
  final String subscribersCount;
  final int rank;
  final bool isRankUp;
  final bool isLast;

  const LeagueListItemWidget({
    super.key,
    required this.title,
    required this.subscribersCount,
    required this.rank,
    required this.isRankUp,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(color: AppColors.blackColor171C),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.font14whiteColorColorW400,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpace(4),
                Text(
                  subscribersCount,
                  style: TextStyles.font12greyColorColor79W400.copyWith(
                    color: AppColors.whiteColorD9,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(12),
          if (!isLast) ...[
            SvgPicture.asset(
              isRankUp
                  ? ImageAsset.arrowCircleUpIcon
                  : ImageAsset.arrowCircleDownIcon,
              width: 16.sp,
              height: 16.sp,
            ),
            horizontalSpace(12),
          ],
          Text(
            _formatNumberLocale(rank),
            style: TextStyles.font16WhiteColorW600,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  String _formatNumberLocale(int number) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return number.toString().replaceAllMapped(
      reg,
      (Match match) => '${match[1]},',
    );
  }
}
