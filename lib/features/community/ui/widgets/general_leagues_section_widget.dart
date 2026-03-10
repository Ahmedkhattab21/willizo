import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/data/models/league_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/league_list_item_widget.dart';

class GeneralLeaguesSectionWidget extends StatelessWidget {
  const GeneralLeaguesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        final cubit = CommunityCubit.get(context);
        final isLoading = state is LeaguesLoadingState;
        final leagues = cubit.generalLeagues;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "General Leagues",
              style: TextStyles.font18WhiteColor700.copyWith(fontSize: 20.sp),
            ),
            verticalSpace(16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.greenColorEF, AppColors.greenColorFD],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.blackColor171C,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: AppColors.blueColorFB,
                            size: 24.sp,
                          ),
                          horizontalSpace(8),
                          Text("League", style: TextStyles.font16WhiteColorW600),
                          const Spacer(),
                          Text(
                            "Members",
                            style: TextStyles.font12greyColorColor79W400.copyWith(
                              color: AppColors.whiteColorD9,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.whiteColorD9,
                      thickness: 0.5,
                      height: 1,
                    ),
                    if (isLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else if (leagues.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: const Center(
                          child: Text(
                            "No general leagues yet",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      )
                    else
                      ..._buildItems(leagues),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildItems(List<LeagueModel> leagues) {
    return leagues.asMap().entries.map((entry) {
      final isLast = entry.key == leagues.length - 1;
      final league = entry.value;
      return LeagueListItemWidget(
        title: league.name,
        subscribersCount: "${league.membersCount} members",
        rank: league.membersCount,
        isRankUp: false,
        isLast: isLast,
      );
    }).toList();
  }
}
