import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/features/community/data/models/feed_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';

class FeedPostWidget extends StatefulWidget {
  final FeedModel feed;

  const FeedPostWidget({super.key, required this.feed});

  @override
  State<FeedPostWidget> createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget>
    with TickerProviderStateMixin {
  final Map<String, AnimationController> _controllers = {};
  final Map<String, Animation<double>> _animations = {};

  AnimationController _getController(String type) {
    if (!_controllers.containsKey(type)) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      _controllers[type] = controller;
      _animations[type] = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
      ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }
    return _controllers[type]!;
  }

  void _onReact(String type) {
    final controller = _getController(type);
    controller.forward(from: 0);
    CommunityCubit.get(context).reactToFeed(widget.feed.id, type);
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  FeedModel get feed => widget.feed;

  Widget _buildAnimatedReaction({
    required String type,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required Color activeColor,
  }) {
    final isActive = feed.userReaction == type;
    final reaction = feed.reactions.where((r) => r.type == type).firstOrNull;
    final count = reaction?.count ?? 0;
    _getController(type);

    return GestureDetector(
      onTap: () => _onReact(type),
      child: ScaleTransition(
        scale: _animations[type] ?? AlwaysStoppedAnimation(1.0),
        child: Row(
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? activeColor : AppColors.whiteColor,
              size: 20.r,
            ),
            if (count > 0) ...[
              horizontalSpace(4),
              Text(
                '$count',
                style: TextStyles.font12greyColorColor79W400.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.greyColorColor79,
                backgroundImage: feed.user.profilePhoto != null
                    ? NetworkImage(feed.user.profilePhoto!)
                    : null,
                child: feed.user.profilePhoto == null
                    ? Icon(
                        Icons.person,
                        color: AppColors.whiteColor,
                        size: 20.r,
                      )
                    : null,
              ),
              horizontalSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feed.user.fullName,
                      style: TextStyles.font14WhiteColorW500,
                    ),
                    Text(
                      feed.timeAgo,
                      style: TextStyles.font12greyColorColor79W400.copyWith(
                        color: AppColors.greyColorColor80,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_horiz,
                  color: AppColors.greyColorColor80,
                  size: 24.r,
                ),
              ),
            ],
          ),
        ),
        // Content
        if (feed.content.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              feed.content,
              style: TextStyles.font14WhiteColorW500.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        // Image
        if (feed.mediaUrl != null && feed.mediaUrl!.isNotEmpty) ...[
          verticalSpace(8),
          SizedBox(
            width: double.infinity,
            height: 375.h,
            child: Image.network(
              feed.mediaUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.greyColorColor79.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.greyColorColor79.withValues(alpha: 0.3),
                  child: Icon(
                    Icons.broken_image,
                    color: AppColors.greyColorColor80,
                    size: 40.r,
                  ),
                );
              },
            ),
          ),
        ],
        // Reactions
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              _buildAnimatedReaction(
                type: 'heart',
                activeIcon: Icons.favorite,
                inactiveIcon: Icons.favorite_border,
                activeColor: Colors.red,
              ),
              horizontalSpace(16),
              _buildAnimatedReaction(
                type: 'like',
                activeIcon: Icons.thumb_up,
                inactiveIcon: Icons.thumb_up_outlined,
                activeColor: Colors.blue,
              ),
              horizontalSpace(16),
              _buildAnimatedReaction(
                type: 'smile',
                activeIcon: Icons.emoji_emotions,
                inactiveIcon: Icons.emoji_emotions_outlined,
                activeColor: Colors.amber,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    CommunityCubit.get(context).saveFeed(feed.id),
                child: Icon(
                  feed.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: feed.isSaved
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  size: 22.r,
                ),
              ),
              horizontalSpace(16),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  ImageAsset.sharePostIcon,
                  height: 14.r,
                  width: 14.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.whiteColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (feed.reactionsCount > 0)
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
            child: Text(
              "${feed.reactionsCount} reactions",
              style: TextStyles.font12greyColorColor79W400.copyWith(
                color: AppColors.greyColorColor80,
              ),
            ),
          ),
      ],
    );
  }
}
