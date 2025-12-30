import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/cart/data/repos/cart_repo.dart';
import 'package:willizo/features/wishlist/data/repos/wishlist_repo.dart';

class BadgeState {
  final int cartCount;
  final int wishlistCount;

  const BadgeState({this.cartCount = 0, this.wishlistCount = 0});

  BadgeState copyWith({int? cartCount, int? wishlistCount}) {
    return BadgeState(
      cartCount: cartCount ?? this.cartCount,
      wishlistCount: wishlistCount ?? this.wishlistCount,
    );
  }
}

class BadgeCubit extends Cubit<BadgeState> {
  final CartRepo cartRepo;
  final WishlistRepo wishlistRepo;

  BadgeCubit({required this.cartRepo, required this.wishlistRepo})
      : super(const BadgeState());

  /// Fetch both counts from API
  Future<void> fetchBadgeCounts() async {
    // Fetch cart count
    final cartResponse = await cartRepo.getCart();
    cartResponse.fold(
      (failure) => null,
      (cart) => emit(state.copyWith(cartCount: cart.data.totalItems)),
    );

    // Fetch wishlist count
    final wishlistResponse = await wishlistRepo.getWishlist();
    wishlistResponse.fold(
      (failure) => null,
      (wishlist) => emit(state.copyWith(wishlistCount: wishlist.data.length)),
    );
  }

  void updateCartCount(int count) => emit(state.copyWith(cartCount: count));
  void updateWishlistCount(int count) => emit(state.copyWith(wishlistCount: count));

  void incrementCartCount() => emit(state.copyWith(cartCount: state.cartCount + 1));
  void decrementCartCount() {
    if (state.cartCount > 0) {
      emit(state.copyWith(cartCount: state.cartCount - 1));
    }
  }

  void incrementWishlistCount() => emit(state.copyWith(wishlistCount: state.wishlistCount + 1));
  void decrementWishlistCount() {
    if (state.wishlistCount > 0) {
      emit(state.copyWith(wishlistCount: state.wishlistCount - 1));
    }
  }
}

