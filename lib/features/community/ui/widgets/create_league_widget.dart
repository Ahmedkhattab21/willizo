import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/app_text_field.dart';
import 'package:willizo/features/community/ui/widgets/join_league_widget.dart';

class CreateLeagueWidget extends StatefulWidget {
  final VoidCallback? onCreateLeague;

  const CreateLeagueWidget({super.key, this.onCreateLeague});

  @override
  State<CreateLeagueWidget> createState() => _CreateLeagueWidgetState();
}

class _CreateLeagueWidgetState extends State<CreateLeagueWidget> {
  bool _showCreateForm = false;
  final _leagueNameController = TextEditingController();
  bool _hasName = false;

  @override
  void initState() {
    super.initState();
    _leagueNameController.addListener(() {
      final hasText = _leagueNameController.text.isNotEmpty;
      if (hasText != _hasName) setState(() => _hasName = hasText);
    });
  }

  @override
  void dispose() {
    _leagueNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showCreateForm) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create an Invitational League",
            style: TextStyles.font18WhiteColor700.copyWith(fontSize: 20.sp),
          ),
          verticalSpace(24),
          Text("League Name", style: TextStyles.font14WhiteColorW500),
          verticalSpace(8),
          AppTextFormField(
            hintText: "Enter League Name",
            hintStyle: TextStyles.font14greyColorColorW400,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 20.w,
            ),
            textStyle: TextStyles.font14whiteColorColorW400,
            controller: _leagueNameController,
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
          verticalSpace(12),
          Text(
            "Please think carefully before entering your league name. Please refer to the Terms & Conditions of entry for more information.",
            style: TextStyles.font12greyColorColor79W400.copyWith(
              color: AppColors.greyColorColor80,
            ),
          ),
          verticalSpace(24),
          GradientJoinButtonWidget(
            isEnabled: _hasName,
            onTap: _hasName ? widget.onCreateLeague : null,
            label: "Create a league",
            icon: Icons.add,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create an Invitational League",
          style: TextStyles.font18WhiteColor700.copyWith(fontSize: 20.sp),
        ),
        verticalSpace(8),
        Text(
          "Create your own league and add your friends.",
          style: TextStyles.font12greyColorColor79W400.copyWith(
            color: AppColors.greyColorColor80,
          ),
        ),
        verticalSpace(24),
        Text(
          "Classic Leagues",
          style: TextStyles.font16WhiteColorW600.copyWith(fontSize: 18.sp),
        ),
        verticalSpace(8),
        Text(
          "In a league with classic scoring, teams are ranked based on their total points in the game. You can join or leave a league with classic scoring at any point during the season.",
          style: TextStyles.font12greyColorColor79W400.copyWith(
            color: AppColors.whiteColorEb,
          ),
        ),
        verticalSpace(24),
        GradientJoinButtonWidget(
          onTap: () => setState(() => _showCreateForm = true),
          label: "Create a league",
          icon: Icons.add,
        ),
      ],
    );
  }
}
