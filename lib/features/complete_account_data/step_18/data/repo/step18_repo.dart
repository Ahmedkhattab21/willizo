import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/complete_account_data/step_18/data/models/gym_equipments_response_model.dart';
import 'package:willizo/features/complete_account_data/step_18/data/services/step18_services.dart';

class Step18Repo {
  final Step18Services step18services;
  Step18Repo(this.step18services);

  Future<Either<Failure, GymEquipmentsResponse>> getGymEquipments() async {
    try {
      return Right(await step18services.getGymEquipments());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
