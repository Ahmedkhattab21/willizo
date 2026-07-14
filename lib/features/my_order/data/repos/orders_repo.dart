import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/my_order/data/models/orders_response_model.dart';
import 'package:willizo/features/my_order/data/services/orders_service.dart';

class OrdersRepo {
  final OrdersService ordersService;

  OrdersRepo(this.ordersService);

  Future<Either<Failure, OrdersResponseModel>> getOrders() async {
    try {
      return Right(await ordersService.getOrders());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, OrderDetailsResponseModel>> getOrderDetails(
    String orderId,
  ) async {
    try {
      return Right(await ordersService.getOrderDetails(orderId));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
