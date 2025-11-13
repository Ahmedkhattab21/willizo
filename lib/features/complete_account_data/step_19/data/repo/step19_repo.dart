import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/complete_account_data/step_19/data/models/free_weight_response_model.dart';
import 'package:willizo/features/complete_account_data/step_19/data/services/step19_services.dart';

class Step19Repo {
  final Step19Services step19services;
  Step19Repo(this.step19services);

  Future<Either<Failure, FreeWeightsResponse>> getFreeWeights() async {
    try {
      return Right(await step19services.getFreeWeight());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
