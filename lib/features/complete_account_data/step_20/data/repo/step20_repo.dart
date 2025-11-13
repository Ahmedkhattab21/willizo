import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/complete_account_data/step_19/data/models/free_weight_response_model.dart';
import 'package:willizo/features/complete_account_data/step_19/data/services/step19_services.dart';
import 'package:willizo/features/complete_account_data/step_20/data/models/supprotive_tool_response_model.dart';
import 'package:willizo/features/complete_account_data/step_20/data/services/step20_services.dart';

class Step20Repo {
  final Step20Services step20services;
  Step20Repo(this.step20services);

  Future<Either<Failure, SupportiveToolsResponse>> getSupportiveTools() async {
    try {
      return Right(await step20services.getSupportiveTools());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
