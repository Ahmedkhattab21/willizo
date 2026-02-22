import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/app_text_field.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/community/data/repo/community_repo.dart';

void showAddFriendDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: AppColors.blackColor.withValues(alpha: 0.6),
    builder: (context) => const _AddFriendDialogContent(),
  );
}

class _AddFriendDialogContent extends StatefulWidget {
  const _AddFriendDialogContent();

  @override
  State<_AddFriendDialogContent> createState() =>
      _AddFriendDialogContentState();
}

class _AddFriendDialogContentState extends State<_AddFriendDialogContent> {
  final TextEditingController _controller = TextEditingController();
  final bool _isLoading = false;
  bool _isInviteLinkGenerated = false;
  String _generatedInviteUrl = '';
  bool _isLoadingInvite = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAddFriend() {
    // Add logic here when backend is ready
    Navigator.of(context).pop();
  }

  void _handleCopyLink() {
    Clipboard.setData(ClipboardData(text: _generatedInviteUrl));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Link copied to clipboard')));
  }

  void _handleInviteLink() async {
    if (_isInviteLinkGenerated) {
      Share.share('Connect with me on FitRank! $_generatedInviteUrl');
      return;
    }

    setState(() { 
      _isLoadingInvite = true;
    });

    final repo = getIt<CommunityRepo>();
    final result = await repo.generateInviteLink();

    if (mounted) {
      setState(() {
        _isLoadingInvite = false;
      });
      result.fold(
        (failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        },
        (url) {
          setState(() {
            _isInviteLinkGenerated = true;
            _generatedInviteUrl = url;
            _controller.text = url;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xff111400),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_add_alt_1,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                    horizontalSpace(8),
                    Text(
                      'Add New Friend',
                      style: TextStyles.font18WhiteColorW600.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.close,
                    color: AppColors.greyColor75,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            verticalSpace(16),
            Divider(color: AppColors.greyColor3d, thickness: 1, height: 1),
            verticalSpace(24),
            if (_isInviteLinkGenerated) ...[
              Text(
                'Your Invite Link:',
                style: TextStyles.font16White2ColorW600,
              ),
              verticalSpace(12),
            ],
            AppTextFormField(
              hintText: _isInviteLinkGenerated ? '' : 'Your Friend ID',
              hintStyle: TextStyles.font14InterW400.copyWith(
                color: AppColors.greyColorColor,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 14.h,
                horizontal: 20.w,
              ),
              textStyle: TextStyles.font14InterW400.copyWith(
                color: AppColors.whiteColor,
              ),
              controller: _controller,
              backgroundColor: Colors.transparent,
              prefixIcon: _isInviteLinkGenerated
                  ? null
                  : Icon(Icons.person, color: AppColors.greyColor75),
              textAlign: _isInviteLinkGenerated
                  ? TextAlign.center
                  : TextAlign.start,
              isEnable: !_isInviteLinkGenerated,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.redColor, width: 2.w),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.redColor, width: 2.w),
                borderRadius: BorderRadius.circular(10.r),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Enter Value";
                }
                return null;
              },
              keyboardType: TextInputType.text,
            ),
            verticalSpace(40),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    isLoading: _isLoadingInvite,
                    buttonText: _isInviteLinkGenerated
                        ? 'Share Invite'
                        : 'Invite Link',
                    textStyle: TextStyles.font14InterW600.copyWith(
                      color: AppColors.primaryColor,
                    ),
                    backGroundColor: Colors.transparent,
                    fourGroundColor: AppColors.primaryColor,
                    borderColor: AppColors.primaryColor,
                    borderWidth: 1.w,
                    borderRadius: 6.r,
                    buttonHeight: 40.h,
                    onPressed: _handleInviteLink,
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: ButtonWidget(
                    isLoading: _isInviteLinkGenerated ? false : _isLoading,
                    buttonText: _isInviteLinkGenerated
                        ? 'Copy Link'
                        : 'Add Friend',
                    textStyle: TextStyles.font14InterW600.copyWith(
                      color: AppColors.blackColor,
                    ),
                    backGroundColor: AppColors.primaryColor,

                    fourGroundColor: AppColors.blackColor,
                    borderRadius: 6.r,
                    buttonHeight: 40.h,
                    onPressed: _isInviteLinkGenerated
                        ? _handleCopyLink
                        : _handleAddFriend,
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
