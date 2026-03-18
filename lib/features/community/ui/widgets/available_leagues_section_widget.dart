import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/data/models/league_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';

class AvailableLeaguesSectionWidget extends StatefulWidget {
  const AvailableLeaguesSectionWidget({super.key});

  @override
  State<AvailableLeaguesSectionWidget> createState() =>
      _AvailableLeaguesSectionWidgetState();
}

class _AvailableLeaguesSectionWidgetState
    extends State<AvailableLeaguesSectionWidget> {
  bool _showAll = false;

  static const int _previewCount = 5;

  @override
  void initState() {
    super.initState();
    CommunityCubit.get(context).getAvailableLeagues();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      buildWhen: (_, state) =>
          state is AvailableLeaguesLoadingState ||
          state is AvailableLeaguesLoadedState ||
          state is AvailableLeaguesErrorState,
      builder: (context, state) {
        final cubit = CommunityCubit.get(context);
        final isLoading = state is AvailableLeaguesLoadingState;
        final allLeagues = cubit.availableLeagues;
        final displayed = _showAll
            ? allLeagues
            : allLeagues.take(_previewCount).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Leagues",
                  style: TextStyles.font18WhiteColor700.copyWith(
                    fontSize: 20.sp,
                  ),
                ),
                if (allLeagues.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => _showAll = !_showAll),
                    child: Text(
                      _showAll ? "View less" : "View all",
                      style: TextStyles.font12GreenColorW500,
                    ),
                  ),
              ],
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
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.blueColorFB,
                              shape: BoxShape.circle,
                            ),
                            width: 24.w,
                            height: 24.h,
                            child: SvgPicture.asset(ImageAsset.whiteCrownIcon),
                          ),
                          horizontalSpace(8),
                          Text(
                            "League",
                            style: TextStyles.font16WhiteColorW600,
                          ),
                          const Spacer(),
                          Text(
                            "Members",
                            style: TextStyles.font10InterW400.copyWith(
                              color: AppColors.greyColorColor79,
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
                    else if (allLeagues.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: const Center(
                          child: Text(
                            "No available leagues",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      )
                    else
                      ...displayed.asMap().entries.map((entry) {
                        final isLast = entry.key == displayed.length - 1;
                        return _AvailableLeagueItem(
                          league: entry.value,
                          isLast: isLast,
                        );
                      }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AvailableLeagueItem extends StatelessWidget {
  final LeagueModel league;
  final bool isLast;

  const _AvailableLeagueItem({required this.league, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      league.name,
                      style: TextStyles.font14whiteColorColorW400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    verticalSpace(4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            league.id,
                            style: TextStyles.font12greyColorColor79W400
                                .copyWith(
                                  color: AppColors.greyColorColor79,
                                  fontSize: 10.sp,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        horizontalSpace(4),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: league.id));
                          },
                          child: Icon(
                            Icons.copy,
                            size: 12.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              horizontalSpace(12),
              Text(
                "${league.membersCount}",
                style: TextStyles.font16WhiteColorW600,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(color: AppColors.whiteColorD9, thickness: 0.5, height: 1),
      ],
    );
  }
}
