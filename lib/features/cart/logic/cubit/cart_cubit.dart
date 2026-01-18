import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';
import 'package:willizo/features/cart/data/repos/cart_repo.dart';
import 'package:willizo/features/cart/logic/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;

  // Debounce timers for each cart item
  final Map<String, Timer> _debounceTimers = {};

  // Debounce duration (Noon-like: wait for user to stop tapping)
  static const _debounceDuration = Duration(milliseconds: 500);

  CartCubit(this.cartRepo) : super(CartInitial());

  Future<void> getCart() async {
    emit(CartLoading());
    final response = await cartRepo.getCart();
    response.fold(
      (l) => emit(CartError(l.message)),
      (r) => emit(CartLoaded(r)),
    );
  }

  /// Increment quantity for a cart item
  void incrementQuantity(String cartItemId, int currentQuantity) {
    _updateQuantity(cartItemId, currentQuantity + 1);
  }

  /// Decrement quantity for a cart item (minimum 1)
  void decrementQuantity(String cartItemId, int currentQuantity) {
    if (currentQuantity > 1) {
      _updateQuantity(cartItemId, currentQuantity - 1);
    }
  }

  /// Update quantity with optimistic UI and debounced API call
  void _updateQuantity(String cartItemId, int newQuantity) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    // Cancel any existing debounce timer for this item
    _debounceTimers[cartItemId]?.cancel();

    // Optimistic UI update - update local quantity immediately
    final updatedLocalQuantities = Map<String, int>.from(
      currentState.localQuantities,
    );
    updatedLocalQuantities[cartItemId] = newQuantity;

    emit(currentState.copyWith(localQuantities: updatedLocalQuantities));

    // Debounce the API call
    _debounceTimers[cartItemId] = Timer(_debounceDuration, () {
      _callUpdateApi(cartItemId, newQuantity);
    });
  }

  /// Call the API to update cart item quantity
  Future<void> _callUpdateApi(String cartItemId, int quantity) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    // Mark item as updating (show loading indicator)
    final updatingIds = Set<String>.from(currentState.updatingItemIds);
    updatingIds.add(cartItemId);
    emit(currentState.copyWith(updatingItemIds: updatingIds));

    final response = await cartRepo.updateCartItemQuantity(
      cartItemId: cartItemId,
      quantity: quantity,
    );

    final latestState = state;
    if (latestState is! CartLoaded) return;

    response.fold(
      (failure) {
        // Revert local quantity on failure
        final revertedLocalQuantities = Map<String, int>.from(
          latestState.localQuantities,
        );
        revertedLocalQuantities.remove(cartItemId);

        final updatedUpdatingIds = Set<String>.from(latestState.updatingItemIds);
        updatedUpdatingIds.remove(cartItemId);

        emit(
          latestState.copyWith(
            localQuantities: revertedLocalQuantities,
            updatingItemIds: updatedUpdatingIds,
          ),
        );
      },
      (updateResponse) {
        // Update cart with server response
        final updatedCartData = CartResponseModel(data: updateResponse.cart);

        // Clear local quantity since server has the truth now
        final clearedLocalQuantities = Map<String, int>.from(
          latestState.localQuantities,
        );
        clearedLocalQuantities.remove(cartItemId);

        final updatedUpdatingIds = Set<String>.from(latestState.updatingItemIds);
        updatedUpdatingIds.remove(cartItemId);

        emit(
          CartLoaded(
            updatedCartData,
            updatingItemIds: updatedUpdatingIds,
            localQuantities: clearedLocalQuantities,
          ),
        );
      },
    );
  }

  /// Clear all items from the cart
  Future<void> clearCart() async {
    emit(CartClearing());

    final response = await cartRepo.clearCart();

    response.fold(
      (failure) => emit(CartError(failure.message)),
      (clearResponse) => emit(CartCleared(clearResponse.message)),
    );
  }

  /// Delete a single item from the cart
  Future<void> deleteCartItem(String cartItemId) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    // Mark item as being deleted (show loading/fade effect)
    final deletingIds = Set<String>.from(currentState.deletingItemIds);
    deletingIds.add(cartItemId);
    emit(currentState.copyWith(deletingItemIds: deletingIds));

    final response = await cartRepo.deleteCartItem(cartItemId: cartItemId);

    final latestState = state;
    if (latestState is! CartLoaded) return;

    response.fold(
      (failure) {
        // Remove from deleting set on failure
        final updatedDeletingIds = Set<String>.from(latestState.deletingItemIds);
        updatedDeletingIds.remove(cartItemId);
        emit(latestState.copyWith(deletingItemIds: updatedDeletingIds));
      },
      (deleteResponse) {
        // Update cart with server response (item removed)
        final updatedCartData = CartResponseModel(data: deleteResponse.cart);

        final updatedDeletingIds = Set<String>.from(latestState.deletingItemIds);
        updatedDeletingIds.remove(cartItemId);

        emit(
          CartLoaded(
            updatedCartData,
            updatingItemIds: latestState.updatingItemIds,
            deletingItemIds: updatedDeletingIds,
            localQuantities: latestState.localQuantities,
          ),
        );
      },
    );
  }

  /// Calculate checkout with address and shipping method
  Future<void> calculateCheckout({
    required int addressId,
    required String shippingMethod,
  }) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      // Update current state with loading indicator for checkout
      emit(currentState.copyWith());
    }
    
    final response = await cartRepo.calculateCheckout(
      addressId: addressId,
      shippingMethod: shippingMethod,
    );
    
    final latestState = state;
    response.fold(
      (l) {
        // Keep cart loaded state but show error if needed
        if (latestState is CartLoaded) {
          emit(latestState);
        }
      },
      (r) {
        // Update cart loaded state with checkout data
        if (latestState is CartLoaded) {
          emit(latestState.copyWith(checkoutData: r));
        } else {
          emit(CheckoutCalculationLoaded(r));
        }
      },
    );
  }

  @override
  Future<void> close() {
    // Cancel all debounce timers when cubit is closed
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    return super.close();
  }
}

