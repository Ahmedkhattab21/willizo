import 'package:equatable/equatable.dart';
import 'package:willizo/features/wishlist/data/models/wishlist_response_model.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final WishlistResponseModel wishlistData;
  final Set<String> deletingProductIds;

  const WishlistLoaded(this.wishlistData, {this.deletingProductIds = const {}});

  bool isDeleting(String productId) => deletingProductIds.contains(productId);

  WishlistLoaded copyWith({
    WishlistResponseModel? wishlistData,
    Set<String>? deletingProductIds,
  }) {
    return WishlistLoaded(
      wishlistData ?? this.wishlistData,
      deletingProductIds: deletingProductIds ?? this.deletingProductIds,
    );
  }

  @override
  List<Object?> get props => [wishlistData, deletingProductIds];
}

class WishlistError extends WishlistState {
  final String message;

  const WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}
