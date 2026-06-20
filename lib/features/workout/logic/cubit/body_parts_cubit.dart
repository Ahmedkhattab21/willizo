import 'package:bloc/bloc.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';
import 'package:willizo/features/workout/data/repo/body_parts_repo.dart';

part 'body_parts_state.dart';

class BodyPartsCubit extends Cubit<BodyPartsState> {
  final BodyPartsRepo bodyPartsRepo;

  BodyPartsCubit(this.bodyPartsRepo) : super(BodyPartsState.initial());

  Future<void> fetchBodyParts() async {
    emit(
      state.copyWith(
        status: BodyPartsLoadStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await bodyPartsRepo.getBodyParts();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BodyPartsLoadStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (groups) {
        emit(
          state.copyWith(
            status: BodyPartsLoadStatus.success,
            groups: groups,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> retry() async {
    await fetchBodyParts();
  }
}
