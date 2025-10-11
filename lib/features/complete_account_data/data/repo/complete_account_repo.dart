import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_response.dart';
import 'package:willizo/features/complete_account_data/data/services/complete_account_service.dart';

class CompleteAccountRepo {
  final CompleteAccountService completeAccountService;

  CompleteAccountRepo({required this.completeAccountService});

  Future<Either<Failure, StepsResponseModel>> sendSteps({
    required StepsRequestModel parameter,
  }) async {
    try {
      return Right(
        await completeAccountService.sendSteps(parameter: parameter),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
