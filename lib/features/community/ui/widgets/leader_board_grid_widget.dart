import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/features/community/data/models/exercise_category_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/challenge_card_widget.dart';

class LeaderboardGrid extends StatelessWidget {
  const LeaderboardGrid({super.key});

  // Map API icon name to local SVG asset
  static String _getIconAsset(String iconName) {
    switch (iconName) {
      case 'push-ups':
        return ImageAsset.coloredDoumble;
      case 'squats':
        return ImageAsset.squatsIcon;
      case 'pull-ups':
        return ImageAsset.pullUpsIcon;
      case 'plank':
        return ImageAsset.plankIcon;
      case 'chest-bench':
        return ImageAsset.coloredDoumble;
      case 'chest-fly':
        return ImageAsset.coloredDoumble;
      case 'deadlift':
        return ImageAsset.coloredDoumble;
      case 'rows':
        return ImageAsset.coloredDoumble;
      case 'lunges':
        return ImageAsset.squatsIcon;
      case 'leg-press':
        return ImageAsset.squatsIcon;
      case 'bicep-curl':
        return ImageAsset.coloredDoumble;
      case 'tricep-dip':
        return ImageAsset.coloredDoumble;
      case 'crunches':
        return ImageAsset.plankIcon;
      case 'twists':
        return ImageAsset.plankIcon;
      case 'running':
        return ImageAsset.squatsIcon;
      case 'cycling':
        return ImageAsset.squatsIcon;
      case 'jump-rope':
        return ImageAsset.squatsIcon;
      case 'burpees':
        return ImageAsset.squatsIcon;
      case 'climbers':
        return ImageAsset.squatsIcon;
      case 'yoga':
        return ImageAsset.plankIcon;
      case 'overhead-press':
        return ImageAsset.overheadPressIcon;
      default:
        return ImageAsset.coloredDoumble;
    }
  }

  // Assign gradient colors based on index (cycling through 4 color pairs)
  static List<Color> _getColors(int index) {
    final colorPairs = [
      [const Color(0xff3B82F6), const Color(0xff2563EB)], // Blue
      [AppColors.purbleColorFA, AppColors.purbleColorEA], // Purple
      [AppColors.greenColorFC, AppColors.greenColor4A], // Green
      [AppColors.orangeColorE9, AppColors.orangeColorFE], // Orange
    ];
    return colorPairs[index % colorPairs.length];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        if (state is LeaderboardLoadedState &&
            state.exerciseCategories.isNotEmpty) {
          // Show the first 4 exercises
          final exercises = state.exerciseCategories.take(4).toList();
          return _buildGrid(exercises);
        }

        // Fallback: show loading or empty grid
        if (state is LeaderboardLoadingState) {
          return SizedBox(
            height: 100.h,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGrid(List<ExerciseCategoryEntry> exercises) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(exercises.length, (index) {
        final entry = exercises[index];
        final colors = _getColors(index);
        final rankText =
            entry.userRank != null ? "#${entry.userRank}" : "#0";
        final participants =
            NumberFormat('#,###').format(entry.participantsCount);

        return ChallengeCard(
          title: entry.exercise.name,
          participants: participants,
          rank: rankText,
          icon: _getIconAsset(entry.exercise.icon),
          startColor: colors[0],
          endColor: colors[1],
          isActive: entry.isActive,
        );
      }),
    );
  }
}
