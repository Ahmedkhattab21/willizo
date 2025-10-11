import 'package:bloc/bloc.dart';
import 'package:willizo/features/home/data/repo/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepo) : super(HomeInitial());

  final HomeRepo homeRepo;

  Future<void> getHome() async {
    emit(HomeLoading());
    final result = await homeRepo.getHome();
    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (home) => emit(HomeLoaded()),
    );
  }
}
