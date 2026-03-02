import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/suggested_friend_card_widget.dart';

class NearYouSection extends StatefulWidget {
  const NearYouSection({super.key});

  @override
  State<NearYouSection> createState() => _NearYouSectionState();
}

class _NearYouSectionState extends State<NearYouSection> {
  static const String _placeholderAvatarUrl =
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CommunityCubit.get(context).getSuggestionsNearYou();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      buildWhen: (previous, current) =>
          current is NearYouSuggestionsLoadingState ||
          current is NearYouSuggestionsLoadedState ||
          current is NearYouSuggestionsErrorState,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                Text(
                  "Near You",
                  style: TextStyles.font18InterW400.copyWith(fontSize: 16.sp),
                ),
                const Spacer(),
                Text(
                  "See All",
                  style: TextStyles.font14primaryColorW600.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            verticalSpace(8),
            Text(
              "People within 5km of your location",
              style: TextStyles.font14greyColorColor79W400.copyWith(
                fontSize: 12.sp,
              ),
            ),
            verticalSpace(16),
            Divider(color: AppColors.greyColor3d, thickness: 1, height: 1),
            _buildBody(state),
            verticalSpace(24),
          ],
        );
      },
    );
  }

  Widget _buildBody(CommunityState state) {
    if (state is NearYouSuggestionsLoadingState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: SizedBox(
            width: 28.w,
            height: 28.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      );
    }

    final cubit = CommunityCubit.get(context);
    final hasLoaded = state is NearYouSuggestionsLoadedState ||
        cubit.hasFetchedNearYouSuggestions;

    if (hasLoaded) {
      final list = cubit.nearYouSuggestions;
      if (list.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Center(
            child: Text(
              "No people found near you",
              style: TextStyles.font14greyColorColor79W400.copyWith(
                fontSize: 13.sp,
              ),
            ),
          ),
        );
      }
      return Column(
        children: list.map((item) {
          final distanceStr = item.distance < 1.0
              ? '${(item.distance * 1000).toInt()}m'
              : '${item.distance.toStringAsFixed(1)}km';
          return SuggestedFriendCardWidget(
            imageUrl: _placeholderAvatarUrl,
            name: item.fullName,
            distance: distanceStr,
            subtitle: '12 mutual friends', // Mock data until backend adds it
          );
        }).toList(),
      );
    }

    if (state is NearYouSuggestionsErrorState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Text(
            "No people found near you",
            style: TextStyles.font14greyColorColor79W400.copyWith(
              fontSize: 13.sp,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
