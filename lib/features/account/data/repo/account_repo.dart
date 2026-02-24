import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/account/data/models/account_resonse.dart';
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
}
