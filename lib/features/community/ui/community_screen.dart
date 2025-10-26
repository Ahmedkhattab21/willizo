import 'package:flutter/material.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/community/ui/widgets/challenges_body_widget.dart';
import 'package:willizo/features/community/ui/widgets/community_tabs_widget.dart';
import 'package:willizo/features/community/ui/widgets/leaderboard_body_widget.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int selectedIndex = 0;

  final List<Widget> tabBodies = const [LeaderboardBody(), ChallengesBody()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            CommunityTabs(
              selectedIndex: selectedIndex,
              onTabSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            Container(
              height: 0.7,
              color: AppColors.greyColorColor79,
              width: double.infinity,
            ),
            verticalSpace(16),

            Expanded(child: tabBodies[selectedIndex]),
           
          ],
        ),
      ),
    );
  }
}
