import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/create_new_password/data/models/reset_password_request_model.dart';
import 'package:willizo/features/create_new_password/data/models/reset_password_response_model.dart';
import 'package:willizo/features/create_new_password/data/services/reset_password_service.dart';

class ResetPasswordRepo {
  final ResetPasswordService resetPasswordService;

  ResetPasswordRepo(this.resetPasswordService);

  Future<Either<Failure, ResetPasswordResponseModel>> resetPassword({
    required ResetPasswordRequestModel requestModel,
  }) async {
    try {
      return Right(
        await resetPasswordService.resetPassword(requestModel: requestModel),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
