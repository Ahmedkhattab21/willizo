import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/all_excercises/ui/all_excersies_screen.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/community_tabs_widget.dart';
import 'package:willizo/features/community/ui/widgets/create_invitational_league_widget.dart';
import 'package:willizo/features/community/ui/widgets/create_league_form_widget.dart';
import 'package:willizo/features/community/ui/widgets/custom_header_widget.dart';
import 'package:willizo/features/community/ui/widgets/join_invitational_league_widget.dart';
import 'package:willizo/features/community/ui/widgets/all_top_friends_body_widget.dart';
import 'package:willizo/features/community/ui/widgets/leaderboard_body_widget.dart';
import 'package:willizo/features/community/ui/widgets/leagues_body_widget.dart';
import 'package:willizo/features/push_ups_leaderboard/ui/puhs_ups_leaderboard_screen.dart';
import 'package:willizo/features/community/ui/widgets/feed_body_widget.dart';
import 'package:willizo/features/community/ui/widgets/friends_tab_body_widget.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityCubit(getIt())..getLeaderboards(),
      child: const CommunityScreenBody(),
    );
  }
}

class CommunityScreenBody extends StatefulWidget {
  const CommunityScreenBody({super.key});

  @override
  State<CommunityScreenBody> createState() => CommunityScreenState();
}

class CommunityScreenState extends State<CommunityScreenBody> {
  int selectedIndex = 0;

  bool showTopFriends = false;
  bool showPushupsLeaderboard = false;
  String? fullLeaderboardExerciseName;
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
                    showJoinInvitationalLeague = false;
                    showCreateLeague = false;
                    showCreateLeagueForm = false;
                  });
                  if (index == 0) {
                    context.read<CommunityCubit>().restoreLeaderboardState();
                  } else if (index == 1) {
                    context.read<CommunityCubit>().getLeagues();
                  }
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
              const Expanded(child: TopFriendsContent()),
            ] else if (showPushupsLeaderboard) ...[
              CustomHeader(
                title:
                    "${fullLeaderboardExerciseName ?? 'Leaderboard'} Leaderboard",
                onBack: () {
                  setState(() {
                    showPushupsLeaderboard = false;
                    fullLeaderboardExerciseName = null;
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
          onViewAllFriendsPressed: () {
            setState(() {
              showTopFriends = true;
            });
          },
          onViewFullLeaderboardPressed: (String exerciseName) {
            setState(() {
              fullLeaderboardExerciseName = exerciseName;
              showPushupsLeaderboard = true;
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
          onCreateLeague: () {
            setState(() {
              showCreateLeague = true;
            });
          },
        );
      case 2:
        return const FriendsTabBodyWidget();
      case 3:
        return const FeedBodyWidget();
      default:
        return const SizedBox.shrink();
    }
  }
}
