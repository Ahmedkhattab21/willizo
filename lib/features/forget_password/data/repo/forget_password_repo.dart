import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/forget_password/data/models/forget_password_response.dart';
import 'package:willizo/features/forget_password/data/services/forget_password_service.dart';

class ForgetPasswordRepo {
  final ForgetPasswordService forgetPasswordService;

  ForgetPasswordRepo(this.forgetPasswordService);

  Future<Either<Failure, ForgetPasswordResponse>> forgetPassword({
    required String emailOrPhone,
  }) async {
    try {
      return Right(
        await forgetPasswordService.forgetPassword(emailOrPhone: emailOrPhone),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
