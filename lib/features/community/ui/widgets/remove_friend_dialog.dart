import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';

/// Confirmation dialog to remove a friend. Uses app style and [ButtonWidget].
/// On OK, calls [cubit.removeFriend] and shows loading on the button.
/// [cubit] must be passed from the caller's context (e.g. context.read<CommunityCubit>())
/// because the dialog's context does not have access to the BlocProvider.
void showRemoveFriendDialog({
  required BuildContext context,
  required CommunityCubit cubit,
  required String friendId,
  required String friendName,
}) {
  showDialog<void>(
    context: context,
    barrierColor: AppColors.blackColor.withValues(alpha: 0.6),
    builder: (dialogContext) => _RemoveFriendDialogContent(
      cubit: cubit,
      friendId: friendId,
      friendName: friendName,
    ),
  );
}

class _RemoveFriendDialogContent extends StatefulWidget {
  final CommunityCubit cubit;
  final String friendId;
  final String friendName;

  const _RemoveFriendDialogContent({
    required this.cubit,
    required this.friendId,
    required this.friendName,
  });

  @override
  State<_RemoveFriendDialogContent> createState() =>
      _RemoveFriendDialogContentState();
}

class _RemoveFriendDialogContentState extends State<_RemoveFriendDialogContent> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleConfirm() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final success = await widget.cubit.removeFriend(widget.friendId);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() => _errorMessage = 'Could not remove friend. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Remove friend',
              style: TextStyles.font20WhiteColorW600,
            ),
            verticalSpace(12),
            Text(
              'Are you sure you want to remove ${widget.friendName} from your friends?',
              style: TextStyles.font14InterW400.copyWith(
                color: AppColors.greyColor75,
              ),
            ),
            if (_errorMessage != null) ...[
              verticalSpace(12),
              Text(
                _errorMessage!,
                style: TextStyles.font10InterW400.copyWith(
                  color: AppColors.redColorF7,
                ),
              ),
            ],
            verticalSpace(24),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    isLoading: false,
                    buttonText: 'Cancel',
                    textStyle: TextStyles.font16White2ColorW600.copyWith(
                      color: AppColors.whiteColor,
                    ),
                    backGroundColor: Colors.transparent,
                    fourGroundColor: AppColors.whiteColor,
                    borderColor: AppColors.greyColor3d,
                    borderWidth: 1,
                    borderRadius: 20.r,
                    onPressed: _isLoading
                        ? () {}
                        : () => Navigator.of(context).pop(),
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: ButtonWidget(
                    isLoading: _isLoading,
                    buttonText: 'Remove',
                    textStyle: TextStyles.font16White2ColorW600.copyWith(
                      color: AppColors.blackColor,
                    ),
                    backGroundColor: AppColors.primaryColor,
                    fourGroundColor: AppColors.blackColor,
                    borderRadius: 20.r,
                    onPressed: _isLoading ? () {} : _handleConfirm,
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
