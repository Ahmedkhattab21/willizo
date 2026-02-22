import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/ui/widgets/suggested_friend_card_widget.dart';
import 'package:willizo/features/community/ui/widgets/top_follower_card_widget.dart';

class SuggestedFriendsTabBodyWidget extends StatelessWidget {
  const SuggestedFriendsTabBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
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
          const SuggestedFriendCardWidget(
            imageUrl:
                "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80",
            name: "Sarah Chen",
            distance: "0.8km",
            subtitle: "12 mutual friends",
          ),
          const SuggestedFriendCardWidget(
            imageUrl:
                "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80",
            name: "Mike Johnson",
            distance: "1.2km",
            subtitle: "8 mutual friends",
          ),
          verticalSpace(24),
          Row(
            children: [
              Column(
                children: [
                  Icon(Icons.phone, color: AppColors.primaryColor, size: 24.sp),
                ],
              ),
              horizontalSpace(8),
              Text(
                "From Your Contacts",
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
            "Friends who joined recently",
            style: TextStyles.font14greyColorColor79W400.copyWith(
              fontSize: 12.sp,
            ),
          ),
          verticalSpace(16),
          Divider(color: AppColors.greyColor3d, thickness: 1, height: 1),
          const SuggestedFriendCardWidget(
            imageUrl:
                "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80",
            name: "Alex Rodriguez",
            subtitle: "+1 (555) 123-4567",
          ),
          const SuggestedFriendCardWidget(
            imageUrl:
                "https://images.unsplash.com/photo-1527980965255-d3b416303d12?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80",
            name: "Lisa Thompson",
            subtitle: "+1 (555) 987-6543",
          ),
          const SuggestedFriendCardWidget(
            imageUrl:
                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80",
            name: "David Park",
            subtitle: "+1 (555) 456-7890",
          ),
          const SuggestedFriendCardWidget(
            imageUrl:
                "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80",
            name: "Maya Patel",
            subtitle: "+1 (555) 321-0987",
          ),
          verticalSpace(24),
          Row(
            children: [
              Column(
                children: [
                  Icon(Icons.star, color: AppColors.primaryColor, size: 24.sp),
                ],
              ),
              horizontalSpace(8),
              Text(
                "Top Followers",
                style: TextStyles.font18InterW400.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
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
            "Popular people you might know",
            style: TextStyles.font14greyColorColor79W400.copyWith(
              fontSize: 12.sp,
            ),
          ),
          verticalSpace(16),
          Divider(color: AppColors.greyColor3d, thickness: 1, height: 1),
          verticalSpace(16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.75, // Adjust based on your cell height
            children: const [
              TopFollowerCardWidget(
                imageUrl:
                    "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80",
                name: "James Wilson",
                followersCount: "2.4K followers",
              ),
              TopFollowerCardWidget(
                imageUrl:
                    "https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80",
                name: "Sophie Davis",
                followersCount: "1.8K followers",
              ),
              TopFollowerCardWidget(
                imageUrl:
                    "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80",
                name: "Ryan Miller",
                followersCount: "3.1K followers",
              ),
              TopFollowerCardWidget(
                imageUrl:
                    "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80",
                name: "Zoe Anderson",
                followersCount: "1.5K followers",
              ),
            ],
          ),
          verticalSpace(32),
        ],
      ),
    );
  }
}
