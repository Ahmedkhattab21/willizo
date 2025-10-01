// import 'package:willizo/core/exceptions/exceptions.dart';
// import 'package:willizo/core/exceptions/failure.dart';
// import 'package:dartz/dartz.dart';
// import 'package:willizo/features/user/sign_in/data/models/register_request_model.dart';
// import 'package:willizo/features/user/sign_in/data/models/register_response_model.dart';
// import 'package:willizo/features/user/sign_in/data/services/register_service.dart';
//
// class RegisterRepo {
//   final RegisterService _registerService;
//
//   RegisterRepo(this._registerService);
//
//   Future<Either<Failure, RegisterResponseModel>> sign_in(
//       RegisterRequestModel parameter
//   ) async {
//     try {
//       return Right(await _registerService.sign_in(parameter));
//     } on ServerException catch (failure) {
//       return Left(ServerFailure(message: failure.serverFailure.message));
//     }
//   }
// }
