// import 'package:smart_app/core/exceptions/exceptions.dart';
// import 'package:smart_app/core/exceptions/failure.dart';
// import 'package:smart_app/features/user/login/data/models/login_request_model.dart';
// import 'package:smart_app/features/user/login/data/models/login_response_model.dart';
// import 'package:smart_app/features/user/login/data/services/login_service.dart';
// import 'package:dartz/dartz.dart';
//
// class LoginRepo {
//   final LoginService _loginService;
//
//   LoginRepo(this._loginService);
//
//   Future<Either<Failure, LoginResponseModel>> login(
//       bool isClient,
//       LoginRequestModel parameter
//   ) async {
//     try {
//       return Right(await _loginService.login(isClient,parameter));
//     } on ServerException catch (failure) {
//       return Left(ServerFailure(message: failure.serverFailure.message));
//     }
//   }
// }
