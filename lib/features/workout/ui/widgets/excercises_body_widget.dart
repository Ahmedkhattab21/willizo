import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';
import 'package:willizo/features/workout/logic/cubit/body_parts_cubit.dart';
import 'package:willizo/features/workout/ui/widgets/exercises/model_viewer_section.dart';
import 'package:willizo/features/workout/ui/widgets/exercises/muscle_group_grid.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BodyPartsCubit, BodyPartsState>(
      builder: (context, state) {
        final loadedGroups = state.status == BodyPartsLoadStatus.success
            ? state.groups
            : <BodyPartModel>[];
        return Column(
          children: [
            Expanded(
              flex: 11,
              child: ModelViewerSection(bodyPartGroups: loadedGroups),
            ),
            verticalSpace(8),
            Expanded(
              flex: 12,
              child: _buildGridSection(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridSection(BuildContext context, BodyPartsState state) {
    if (state.status == BodyPartsLoadStatus.loading ||
        state.status == BodyPartsLoadStatus.initial) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      );
    }

    if (state.status == BodyPartsLoadStatus.failure) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage ?? 'Failed to load muscle groups',
              style: TextStyles.font14InterW400.copyWith(
                color: Colors.redAccent,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(10),
            TextButton(
              onPressed: () => context.read<BodyPartsCubit>().retry(),
              child: Text(
                'Retry',
                style: TextStyles.font14W700.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.groups.isEmpty) {
      return Center(
        child: Text(
          'No muscle groups available',
          style: TextStyles.font14GreyColorW400,
        ),
      );
    }

    return MuscleGroupGrid(groups: state.groups);
  }
}
