import 'package:equatable/equatable.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartResponseModel cartData;
  // Track items being updated (for showing loading indicator)
  final Set<String> updatingItemIds;
  // Track items being deleted
  final Set<String> deletingItemIds;
  // Track local quantities (for optimistic updates)
  final Map<String, int> localQuantities;

  const CartLoaded(
    this.cartData, {
    this.updatingItemIds = const {},
    this.deletingItemIds = const {},
    this.localQuantities = const {},
  });

  // Get effective quantity for an item (local if exists, otherwise from server)
  int getQuantity(String itemId, int serverQuantity) {
    return localQuantities[itemId] ?? serverQuantity;
  }

  bool isUpdating(String itemId) => updatingItemIds.contains(itemId);
  bool isDeleting(String itemId) => deletingItemIds.contains(itemId);

  CartLoaded copyWith({
    CartResponseModel? cartData,
    Set<String>? updatingItemIds,
    Set<String>? deletingItemIds,
    Map<String, int>? localQuantities,
  }) {
    return CartLoaded(
      cartData ?? this.cartData,
      updatingItemIds: updatingItemIds ?? this.updatingItemIds,
      deletingItemIds: deletingItemIds ?? this.deletingItemIds,
      localQuantities: localQuantities ?? this.localQuantities,
    );
  }

  @override
  List<Object?> get props => [cartData, updatingItemIds, deletingItemIds, localQuantities];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartClearing extends CartState {}

class CartCleared extends CartState {
  final String message;

  const CartCleared(this.message);

  @override
  List<Object?> get props => [message];
}

