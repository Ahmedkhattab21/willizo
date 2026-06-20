import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';
import 'package:willizo/features/workout/data/services/body_parts_services.dart';

class BodyPartsRepo {
  final BodyPartsServices bodyPartsServices;

  BodyPartsRepo(this.bodyPartsServices);

  Future<Either<Failure, List<BodyPartModel>>> getBodyParts() async {
    try {
      final response = await bodyPartsServices.getBodyParts();
      return Right(response.data);
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
