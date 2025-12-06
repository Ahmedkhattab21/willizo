import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';

class LeaguesBody extends StatelessWidget {
  final VoidCallback? onJoinInvitationalLeague;
  final VoidCallback? onJoinGeneralLeague;

  const LeaguesBody({
    super.key,
    this.onJoinInvitationalLeague,
    this.onJoinGeneralLeague,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose a League Type to Join",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          verticalSpace(8),
          Text(
            "You can join up to 20 invitational leagues and 8 public leagues.",
            style: TextStyle(
              color: AppColors.greyColorColor80,
              fontSize: 14.sp,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          verticalSpace(32),

          // Invitational Leagues
          Text(
            "Invitational Leagues",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          verticalSpace(8),
          Text(
            "Join an invitational league if somebody has given you a league code to enter.",
            style: TextStyle(
              color: AppColors.greyColorColor80,
              fontSize: 14.sp,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          verticalSpace(24),
          _buildJoinButton(context, onTap: onJoinInvitationalLeague),

          verticalSpace(24),
          Divider(color: AppColors.greyColorColor80.withOpacity(0.3)),
          verticalSpace(24),

          // General Leagues
          Text(
            "General Leagues",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          verticalSpace(8),
          Text(
            "Join a public league to play with a small, randomly selected group of other game players.",
            style: TextStyle(
              color: AppColors.greyColorColor80,
              fontSize: 14.sp,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          verticalSpace(24),
          _buildJoinButton(context, onTap: onJoinGeneralLeague),
        ],
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context, {VoidCallback? onTap}) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.greenColorEF, AppColors.greenColorFD],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
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
              SvgPicture.asset(ImageAsset.enterIcon),
              horizontalSpace(8),
              Text(
                "Join a league",
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
