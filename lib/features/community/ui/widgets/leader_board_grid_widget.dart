import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/features/community/ui/widgets/challenge_card_widget.dart';

class LeaderboardGrid extends StatelessWidget {
  const LeaderboardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ChallengeCard(
          title: "Push-ups",
          participants: "1,247",
          rank: "#8",
          icon: ImageAsset.coloredDoumble,
          startColor: Color(0xff3B82F6),
          endColor: Color(0xff2563EB),
        ),
        ChallengeCard(
          title: "Squats",
          participants: "892",
          rank: "#15",
          icon: ImageAsset.squatsIcon,
          startColor: AppColors.purbleColorFA,
          endColor: AppColors.purbleColorEA,
        ),
        ChallengeCard(
          title: "Pull-ups",
          participants: "634",
          rank: "#5",
          icon: ImageAsset.pullUpsIcon,
          startColor: AppColors.greenColorFC,
          endColor: AppColors.greenColor4A,
        ),
        ChallengeCard(
          title: "Plank",
          participants: "1,105",
          rank: "#11",
          icon: ImageAsset.plankIcon,
          startColor: AppColors.orangeColorE9,
          endColor: AppColors.orangeColorFE,
        ),
      ],
    );
  }
}
