part of 'body_part_exercises_cubit.dart';

enum BodyPartExercisesLoadStatus { initial, loading, success, failure }

final class BodyPartExercisesState {
  final BodyPartExercisesLoadStatus status;
  final List<BodyPartExerciseModel> exercises;
  final String? errorMessage;

  const BodyPartExercisesState({
    required this.status,
    required this.exercises,
    this.errorMessage,
  });

  factory BodyPartExercisesState.initial() {
    return const BodyPartExercisesState(
      status: BodyPartExercisesLoadStatus.initial,
      exercises: [],
    );
  }

  BodyPartExercisesState copyWith({
    BodyPartExercisesLoadStatus? status,
    List<BodyPartExerciseModel>? exercises,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BodyPartExercisesState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
