import 'package:bloc/bloc.dart';
import 'package:willizo/features/workout/data/models/body_part_exercises_response_model.dart';
import 'package:willizo/features/workout/data/repo/body_parts_repo.dart';

part 'body_part_exercises_state.dart';

class BodyPartExercisesCubit extends Cubit<BodyPartExercisesState> {
  final BodyPartsRepo bodyPartsRepo;

  BodyPartExercisesCubit(this.bodyPartsRepo)
    : super(BodyPartExercisesState.initial());

  Future<void> fetchExercises(String slug) async {
    emit(
      state.copyWith(
        status: BodyPartExercisesLoadStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await bodyPartsRepo.getBodyPartExercises(slug);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BodyPartExercisesLoadStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (exercises) {
        emit(
          state.copyWith(
            status: BodyPartExercisesLoadStatus.success,
            exercises: exercises,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }
}
