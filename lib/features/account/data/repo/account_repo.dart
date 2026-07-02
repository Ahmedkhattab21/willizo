import 'package:dartz/dartz.dart';
import 'package:willizo/core/errors_and_success_response/success/success_response.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/account/data/models/account_resonse.dart';
import 'package:willizo/features/account/data/models/update_profile_request_model.dart';
import 'package:willizo/features/account/data/services/account_services.dart';

class AccountRepo {
  final AccountService _accountServices;

  AccountRepo(this._accountServices);

  Future<Either<Failure, AccountResponseModel>> getAccountData() async {
    try {
      return Right(await _accountServices.getAccountData());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Failed to load profile'));
    }
  }

  Future<Either<Failure, SuccessResponseModel>> logout() async {
    try {
      return Right(await _accountServices.logout());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Failed to logout'));
    }
  }

  Future<Either<Failure, AccountResponseModel>> updateProfile(
    UpdateProfileRequestModel requestModel,
  ) async {
    try {
      return Right(await _accountServices.updateProfile(requestModel));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Failed to update profile'));
    }
  }

  Future<Either<Failure, AccountResponseModel>> updateProfilePhoto(
    String imagePath,
  ) async {
    try {
      return Right(await _accountServices.updateProfilePhoto(imagePath));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(
        ServerFailure(message: 'Failed to update profile photo'),
      );
    }
  }
}
