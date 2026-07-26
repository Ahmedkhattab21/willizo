import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/ui/widgets/available_leagues_section_widget.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/general_leagues_section_widget.dart';
import 'package:willizo/features/community/ui/widgets/invitational_leagues_section_widget.dart';
import 'package:willizo/features/community/ui/widgets/create_league_widget.dart';
import 'package:willizo/features/community/ui/widgets/join_league_widget.dart';

class LeaguesBody extends StatefulWidget {
  final VoidCallback? onCreateLeague;

  const LeaguesBody({super.key, this.onCreateLeague});

  @override
  State<LeaguesBody> createState() => _LeaguesBodyState();
}

class _LeaguesBodyState extends State<LeaguesBody> {
  bool _showJoinLeague = false;
  bool _showCreateLeague = false;

  @override
  Widget build(BuildContext context) {
    if (_showJoinLeague) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const JoinLeagueWidget()],
        ),
      );
    }

    if (_showCreateLeague) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateLeagueWidget(
              onCreateLeague: widget.onCreateLeague,
              onSuccess: () => setState(() => _showCreateLeague = false),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryColor,
      backgroundColor: AppColors.greyColor2727,
      onRefresh: () async {
        final cubit = context.read<CommunityCubit>();
        await Future.wait([
          cubit.getLeagues(refresh: true),
          cubit.getAvailableLeagues(refresh: true),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                  onTap: () => setState(() => _showJoinLeague = true),
                  borderRadius: BorderRadius.circular(30.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        ImageAsset.enterIcon,
                        colorFilter: const ColorFilter.mode(
                          AppColors.blackColor,
                          BlendMode.srcIn,
                        ),
                        height: 20.r,
                        width: 20.r,
                      ),
                      horizontalSpace(8),
                      Text(
                        "Join a league",
                        style: TextStyles.font16WhiteColorW600.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            verticalSpace(16),
            Container(
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
              padding: EdgeInsets.all(1.5),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(28.5.r),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => _showCreateLeague = true),
                    borderRadius: BorderRadius.circular(28.5.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.primaryColor,
                          size: 22.r,
                        ),
                        horizontalSpace(8),
                        Text(
                          "Create a league",
                          style: TextStyles.font16WhiteColorW600.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            verticalSpace(24),
            const AvailableLeaguesSectionWidget(),
            verticalSpace(24),
            const GeneralLeaguesSectionWidget(),
            verticalSpace(24),
            const InvitationalLeaguesSectionWidget(),
          ],
        ),
      ),
    );
  }
}
