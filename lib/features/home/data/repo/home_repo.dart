import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/home/data/models/home_model.dart';
import 'package:willizo/features/home/data/services/home_services.dart';

class HomeRepo {
  final HomeServices homeServices;

  HomeRepo(this.homeServices);

  Future<Either<Failure, HomeResponseModel>> getHome() async {
    try {
      return Right(await homeServices.getHome());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
