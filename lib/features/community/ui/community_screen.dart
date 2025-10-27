import 'package:flutter/material.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/all_excercises/ui/all_excersies_screen.dart';
import 'package:willizo/features/community/ui/widgets/challenges_body_widget.dart';
import 'package:willizo/features/community/ui/widgets/community_tabs_widget.dart';
import 'package:willizo/features/community/ui/widgets/custom_header_widget.dart';
import 'package:willizo/features/community/ui/widgets/leaderboard_body_widget.dart';
import 'package:willizo/features/push_ups_leaderboard/ui/puhs_ups_leaderboard_screen.dart';
import 'package:willizo/features/top_friends/ui/top_friends_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => CommunityScreenState();
}

class CommunityScreenState extends State<CommunityScreen> {
  int selectedIndex = 0;

  bool showTopFriends = false;
  bool showPushupsLeaderboard = false;
  bool showExercises = false;

  final List<Widget> tabBodies = const [LeaderboardBody(), ChallengesBody()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            if (!showTopFriends &&
                !showPushupsLeaderboard &&
                !showExercises) ...[
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
              Expanded(
                child: LeaderboardBody(
                  onViewAllPressed: () {
                    setState(() {
                      showExercises = true;
                    });
                  },
                ),
              ),
            ]
            else if (showTopFriends) ...[
              CustomHeader(
                title: "Top Friends",
                onBack: () {
                  setState(() {
                    showTopFriends = false;
                  });
                },
              ),
              const Expanded(child: TopFriendsScreen()),
            ] else if (showPushupsLeaderboard) ...[
              CustomHeader(
                title: "Push-ups Leaderboard",
                onBack: () {
                  setState(() {
                    showPushupsLeaderboard = false;
                  });
                },
              ),
              const Expanded(child: PuhsUpsLeaderboardScreen()),
            ] else if (showExercises) ...[
              CustomHeader(
                title: "Exercises",
                onBack: () {
                  setState(() {
                    showExercises = false;
                  });
                },
              ),
              const Expanded(child: ExercisesScreen()),
            ],
          ],
        ),
      ),
    );
  }
}
