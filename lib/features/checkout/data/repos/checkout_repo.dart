import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/checkout/data/models/address_model.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_request_model.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_response_model.dart';
import 'package:willizo/features/checkout/data/models/create_address_request_model.dart';
import 'package:willizo/features/checkout/data/models/create_address_response_model.dart';
import 'package:willizo/features/checkout/data/models/order_response_model.dart';
import 'package:willizo/features/checkout/data/services/checkout_services.dart';

class CheckoutRepo {
  final CheckoutService checkoutService;

  CheckoutRepo(this.checkoutService);

  Future<Either<Failure, AddressResponseModel>> getAddresses() async {
    try {
      return Right(await checkoutService.getAddresses());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, CreateAddressResponseModel>> createAddress(
    CreateAddressRequestModel request,
  ) async {
    try {
      return Right(await checkoutService.createAddress(request));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, CheckoutCalculationResponseModel>> calculateCheckout(
    CheckoutCalculationRequestModel request,
  ) async {
    try {
      return Right(await checkoutService.calculateCheckout(request));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, OrderResponseModel>> confirmCheckout() async {
    try {
      return Right(await checkoutService.confirmCheckout());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
