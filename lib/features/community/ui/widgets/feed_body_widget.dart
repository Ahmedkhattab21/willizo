import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/feed_post_shimmer_widget.dart';
import 'package:willizo/features/community/ui/widgets/feed_post_widget.dart';
import 'package:willizo/features/community/ui/widgets/share_photo_widget.dart';

class FeedBodyWidget extends StatefulWidget {
  const FeedBodyWidget({super.key});

  @override
  State<FeedBodyWidget> createState() => _FeedBodyWidgetState();
}

class _FeedBodyWidgetState extends State<FeedBodyWidget> {
  @override
  void initState() {
    super.initState();
    CommunityCubit.get(context).getFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      buildWhen: (prev, curr) =>
          curr is FeedsLoadingState ||
          curr is FeedsLoadedState ||
          curr is FeedsErrorState,
      builder: (context, state) {
        final cubit = CommunityCubit.get(context);
        final feeds = cubit.feeds;
        final isLoading = state is FeedsLoadingState;

        return RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: AppColors.greyColor2727,
          onRefresh: () => cubit.getFeeds(refresh: true),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: const SharePhotoWidget(),
                ),
              ),
              if (isLoading)
                const SliverToBoxAdapter(child: FeedPostShimmerWidget())
              else if (feeds.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Center(
                      child: Text(
                        "No feeds yet",
                        style: TextStyle(
                          color: AppColors.greyColorColor80,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverList.separated(
                  itemCount: feeds.length,
                  separatorBuilder: (_, __) => Divider(
                    color: AppColors.greyColorColor79.withValues(alpha: 0.3),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    return FeedPostWidget(feed: feeds[index]);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
