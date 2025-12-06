import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/login_and_signup/data/models/get_onboarding_step_response.dart';
import 'package:willizo/features/login_and_signup/data/models/login_request_model.dart';
import 'package:willizo/features/login_and_signup/data/models/login_response_model.dart';
import 'package:willizo/features/login_and_signup/data/models/signup_request_model.dart';
import 'package:willizo/features/login_and_signup/data/models/signup_resopnse_model.dart';
import 'package:willizo/features/login_and_signup/data/services/login_and_signup_service.dart';

class LoginAndSignupRepo {
  final LoginAndSignupService loginAndSignupService;

  LoginAndSignupRepo(this.loginAndSignupService);

  Future<Either<Failure, LoginResponseModel>> lgoin(
    LoginRequestModel parameter,
  ) async {
    try {
      return Right(await loginAndSignupService.login(parameter));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, SignupResponseModel>> signup(
    SignupRequestModel parameter,
  ) async {
    try {
      return Right(await loginAndSignupService.signup(parameter));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, GetOnboardingStepResponseModel>> getOnboardingStatus() async {
    try {
      return Right(await loginAndSignupService.getOnboardingStatus());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
