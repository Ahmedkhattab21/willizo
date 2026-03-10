import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/app_text_field.dart';

class JoinLeagueWidget extends StatefulWidget {
  final VoidCallback? onJoinInvitationalLeague;

  const JoinLeagueWidget({super.key, this.onJoinInvitationalLeague});

  @override
  State<JoinLeagueWidget> createState() => _JoinLeagueWidgetState();
}

class _JoinLeagueWidgetState extends State<JoinLeagueWidget> {
  bool _showInvitationalForm = false;
  final _leagueCodeController = TextEditingController();
  bool _hasCode = false;

  @override
  void initState() {
    super.initState();
    _leagueCodeController.addListener(() {
      final hasText = _leagueCodeController.text.isNotEmpty;
      if (hasText != _hasCode) setState(() => _hasCode = hasText);
    });
  }

  @override
  void dispose() {
    _leagueCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showInvitationalForm) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Join an Invitational League",
            style: TextStyles.font18WhiteColor700.copyWith(fontSize: 20.sp),
          ),
          verticalSpace(24),
          Text("League Code", style: TextStyles.font14WhiteColorW500),
          verticalSpace(8),
          AppTextFormField(
            hintText: "Enter League Code",
            hintStyle: TextStyles.font14greyColorColorW400,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 20.w,
            ),
            textStyle: TextStyles.font14whiteColorColorW400,
            controller: _leagueCodeController,
            backgroundColor: AppColors.blackColor,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: SvgPicture.asset(ImageAsset.nameIcon),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.redColor, width: 2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.redColor, width: 2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            validator: (value) => null,
            keyboardType: TextInputType.text,
          ),
          verticalSpace(24),
          GradientJoinButtonWidget(
            isEnabled: _hasCode,
            onTap: _hasCode ? widget.onJoinInvitationalLeague : null,
          ),
        ],
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose a League Type to Join",
            style: TextStyles.font18WhiteColor700,
          ),
          verticalSpace(8),
          Text(
            "You can join up to 20 invitational leagues and 8 public leagues.",
            style: TextStyles.font12greyColorColor79W400.copyWith(
              color: AppColors.greyColorColor80,
            ),
          ),
          verticalSpace(20),
          Text(
            "Invitational Leagues",
            style: TextStyles.font16WhiteColorW600.copyWith(fontSize: 18.sp),
          ),
          verticalSpace(8),
          Text(
            "Join an invitational league if somebody has given you a league code to enter.",
            style: TextStyles.font10WhiteColorW400,
          ),
          verticalSpace(24),
          GradientJoinButtonWidget(
            onTap: () => setState(() => _showInvitationalForm = true),
          ),
          verticalSpace(20),
          Divider(color: AppColors.whiteColorD9, thickness: 0.5, height: 1),
          verticalSpace(20),
          Text(
            "General Leagues",
            style: TextStyles.font16WhiteColorW600.copyWith(fontSize: 18.sp),
          ),
          verticalSpace(8),
          Text(
            "Join a public league to play with a small, randomly selected group of other game players.",
            style: TextStyles.font10WhiteColorW400,
          ),
          verticalSpace(24),
          GradientJoinButtonWidget(onTap: widget.onJoinInvitationalLeague),
        ],
      ),
    );
  }
}

class GradientJoinButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isEnabled;
  final String label;
  final IconData? icon;

  const GradientJoinButtonWidget({
    super.key,
    this.onTap,
    this.isEnabled = true,
    this.label = "Join a league",
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? const LinearGradient(
                colors: [AppColors.greenColorEF, AppColors.greenColorFD],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isEnabled ? null : AppColors.greyColorColor79,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(30.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && isEnabled) ...[
                Icon(icon, color: AppColors.blackColor, size: 22.r),
              ] else if (icon == null) ...[
                SvgPicture.asset(
                  ImageAsset.enterIcon,
                  colorFilter: ColorFilter.mode(
                    AppColors.blackColor,
                    BlendMode.srcIn,
                  ),
                  height: 20.r,
                  width: 20.r,
                ),
              ],
              horizontalSpace(8),
              Text(
                label,
                style: TextStyles.font16WhiteColorW600.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
