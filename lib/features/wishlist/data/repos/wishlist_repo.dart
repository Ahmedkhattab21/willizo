import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/wishlist/data/models/remove_wishlist_response.dart';
import 'package:willizo/features/wishlist/data/models/wishlist_response_model.dart';
import 'package:willizo/features/wishlist/data/services/wishlist_service.dart';

class WishlistRepo {
  final WishlistService wishlistService;

  WishlistRepo(this.wishlistService);

  Future<Either<Failure, WishlistResponseModel>> getWishlist() async {
    try {
      return Right(await wishlistService.getWishlist());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, RemoveWishlistResponse>> removeFromWishlist({
    required String productId,
  }) async {
    try {
      return Right(await wishlistService.removeFromWishlist(productId: productId));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
