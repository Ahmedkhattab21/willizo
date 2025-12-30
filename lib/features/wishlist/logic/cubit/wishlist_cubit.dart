import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/wishlist/data/models/wishlist_response_model.dart';
import 'package:willizo/features/wishlist/data/repos/wishlist_repo.dart';
import 'package:willizo/features/wishlist/logic/cubit/wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepo wishlistRepo;

  WishlistCubit(this.wishlistRepo) : super(WishlistInitial());

  Future<void> getWishlist() async {
    emit(WishlistLoading());
    final response = await wishlistRepo.getWishlist();
    response.fold(
      (l) => emit(WishlistError(l.message)),
      (r) => emit(WishlistLoaded(r)),
    );
  }

  Future<void> removeFromWishlist(String productId) async {
    final currentState = state;
    if (currentState is! WishlistLoaded) return;

    // Mark product as being deleted
    final deletingIds = Set<String>.from(currentState.deletingProductIds);
    deletingIds.add(productId);
    emit(currentState.copyWith(deletingProductIds: deletingIds));

    final response = await wishlistRepo.removeFromWishlist(productId: productId);

    final latestState = state;
    if (latestState is! WishlistLoaded) return;

    response.fold(
      (failure) {
        // Remove from deleting set on failure
        final updatedDeletingIds = Set<String>.from(latestState.deletingProductIds);
        updatedDeletingIds.remove(productId);
        emit(latestState.copyWith(deletingProductIds: updatedDeletingIds));
      },
      (removeResponse) {
        // Remove item from local list
        final updatedItems = latestState.wishlistData.data
            .where((item) => item.product.id != productId)
            .toList();

        final updatedDeletingIds = Set<String>.from(latestState.deletingProductIds);
        updatedDeletingIds.remove(productId);

        emit(
          WishlistLoaded(
            WishlistResponseModel(data: updatedItems),
            deletingProductIds: updatedDeletingIds,
          ),
        );
      },
    );
  }
}
