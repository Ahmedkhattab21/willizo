import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/ui/widgets/friends_from_your_contacts_section.dart';
import 'package:willizo/features/community/ui/widgets/friends_top_followers_sectoin.dart';
import 'package:willizo/features/community/ui/widgets/suggested_friend_card_widget.dart';

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
          const FriendsFromYourContactsSection(),
          const FriendsTopFollowersSection(),
        ],
      ),
    );
  }
}
