import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';
import 'package:willizo/features/cart/data/models/checkout_calculation_response_model.dart';
import 'package:willizo/features/cart/data/models/clear_cart_response.dart';
import 'package:willizo/features/cart/data/models/delete_cart_item_response.dart';
import 'package:willizo/features/cart/data/models/update_cart_count_response.dart';
import 'package:willizo/features/cart/data/services/cart_service.dart';

class CartRepo {
  final CartService cartService;

  CartRepo(this.cartService);

  Future<Either<Failure, CartResponseModel>> getCart() async {
    try {
      return Right(await cartService.getCart());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, UpdateCartCountResponse>> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      return Right(await cartService.updateCartItemQuantity(
        cartItemId: cartItemId,
        quantity: quantity,
      ));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, ClearCartResponse>> clearCart() async {
    try {
      return Right(await cartService.clearCart());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, DeleteCartItemResponse>> deleteCartItem({
    required String cartItemId,
  }) async {
    try {
      return Right(await cartService.deleteCartItem(cartItemId: cartItemId));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, CheckoutCalculationResponseModel>> calculateCheckout({
    required int addressId,
    required String shippingMethod,
  }) async {
    try {
      return Right(await cartService.calculateCheckout(
        addressId: addressId,
        shippingMethod: shippingMethod,
      ));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}

