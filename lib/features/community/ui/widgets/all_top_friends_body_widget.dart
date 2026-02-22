import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/features/community/data/models/leaderboard_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/top_friends_board_card.dart';

class TopFriendsContent extends StatelessWidget {
  const TopFriendsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        final friends = state is LeaderboardLoadedState
            ? state.leaderboardFriends
            : <LeaderboardEntry>[];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 2, color: Colors.transparent),
                    gradient: LinearGradient(
                      colors: [AppColors.greenColorEF, AppColors.greenColorFD],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF181C00),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 24,
                                    width: 24,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppColors.blueColorFB,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.group,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Top Friends",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Total Points",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyColorD1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.white, thickness: 1),
                        if (friends.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              "No friends on the leaderboard yet",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.greyColorD1,
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            itemCount: friends.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return FrindInfo(entry: friends[index]);
                            },
                          ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
