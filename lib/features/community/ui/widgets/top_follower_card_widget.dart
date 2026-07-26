import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';

class TopFollowerCardWidget extends StatefulWidget {
  // final String imageUrl;
  final String name;
  final String followersCount;
  final bool isFollowing;
  final Future<bool> Function()? onFollow;

  const TopFollowerCardWidget({
    super.key,
    // required this.imageUrl,
    required this.name,
    required this.followersCount,
    required this.isFollowing,
    this.onFollow,
  });

  @override
  State<TopFollowerCardWidget> createState() => _TopFollowerCardWidgetState();
}

class _TopFollowerCardWidgetState extends State<TopFollowerCardWidget> {
  bool _isLoading = false;

  Future<void> _follow() async {
    if (_isLoading || widget.onFollow == null) return;
    setState(() => _isLoading = true);
    final success = await widget.onFollow!();
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? widget.isFollowing
                    ? 'Unfollowed successfully'
                    : 'Followed successfully'
              : widget.isFollowing
              ? 'Failed to unfollow'
              : 'Failed to follow',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyColor2727,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28.r,
            child: Icon(Icons.person, size: 28.r),
          ),

          verticalSpace(12),
          Text(
            widget.name,
            style: TextStyles.font14whiteColorColorW400,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpace(4),
          Text(
            widget.followersCount,
            style: TextStyles.font12whiteColorColorW400.copyWith(
              color: AppColors.greyColorD1,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpace(16),
          ButtonWidget(
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _follow,
            buttonText: widget.isFollowing ? "Unfollow" : "Follow",
            backGroundColor: widget.isFollowing
                ? AppColors.greyColor33
                : AppColors.primaryColor,
            fourGroundColor: widget.isFollowing
                ? AppColors.whiteColor
                : AppColors.blackColor,
            buttonHeight: 32.h,
            borderRadius: 24,
            textStyle: TextStyles.font14BlackColorW700.copyWith(
              fontSize: 13.sp,
              color: widget.isFollowing
                  ? AppColors.whiteColor
                  : AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
