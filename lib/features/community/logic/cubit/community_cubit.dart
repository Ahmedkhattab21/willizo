import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/community/data/repo/community_repo.dart';

part 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit(this._communityRepo) : super(CommunityInitial());

  final CommunityRepo _communityRepo;

  Future<void> getCommunity() async {
    emit(CommunityLoadingState());
    final result = await _communityRepo.getCommunity();
    result.fold(
      (failure) => emit(CommunityErrorState(failure)),
      (data) => emit(CommunityLoadedState()),
    );
  }
}
