import 'package:flutter/material.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/all_excercises/ui/all_excersies_screen.dart';
import 'package:willizo/features/community/ui/widgets/community_tabs_widget.dart';
import 'package:willizo/features/community/ui/widgets/create_invitational_league_widget.dart';
import 'package:willizo/features/community/ui/widgets/create_league_form_widget.dart';
import 'package:willizo/features/community/ui/widgets/custom_header_widget.dart';
import 'package:willizo/features/community/ui/widgets/join_invitational_league_widget.dart';
import 'package:willizo/features/community/ui/widgets/leaderboard_body_widget.dart';
import 'package:willizo/features/community/ui/widgets/leagues_body_widget.dart';
import 'package:willizo/features/push_ups_leaderboard/ui/puhs_ups_leaderboard_screen.dart';
import 'package:willizo/features/top_friends/ui/top_friends_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => CommunityScreenState();
}

class CommunityScreenState extends State<CommunityScreen> {
  int selectedIndex = 1; // Default to Leagues tab

  bool showTopFriends = false;
  bool showPushupsLeaderboard = false;
  bool showExercises = false;
  bool showJoinInvitationalLeague = false;
  bool showCreateLeague = false;
  bool showCreateLeagueForm = false;

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
                    // Reset nested navigation states when switching tabs
                    showJoinInvitationalLeague = false;
                    showCreateLeague = false;
                    showCreateLeagueForm = false;
                  });
                },
              ),
              Container(
                height: 0.7,
                color: AppColors.greyColorColor79,
                width: double.infinity,
              ),
              verticalSpace(16),
              Expanded(child: _buildTabContent()),
            ] else if (showTopFriends) ...[
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

  Widget _buildTabContent() {
    switch (selectedIndex) {
      case 0:
        return LeaderboardBody(
          onViewAllPressed: () {
            setState(() {
              showExercises = true;
            });
          },
        );
      case 1:
        if (showJoinInvitationalLeague) {
          return const JoinInvitationalLeagueWidget();
        }
        if (showCreateLeagueForm) {
          return const CreateLeagueFormWidget();
        }
        if (showCreateLeague) {
          return CreateInvitationalLeagueWidget(
            onCreateLeague: () {
              setState(() {
                showCreateLeagueForm = true;
              });
            },
          );
        }
        return LeaguesBody(
          onJoinInvitationalLeague: () {
            setState(() {
              showJoinInvitationalLeague = true;
            });
          },
          onJoinGeneralLeague: () {
            setState(() {
              showCreateLeague = true;
            });
          },
        );
      case 2:
        return const TopFriendsScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
