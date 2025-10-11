import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/community/data/models/community_models.dart';
import 'package:willizo/features/community/data/services/community_services.dart';

class CommunityRepo {
  final CommunityServices communityServices;

  CommunityRepo({required this.communityServices});

  Future<Either<Failure, CommunityResponseModel>> getCommunity() async {
    try {
      final response = await communityServices.getCommunity();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  } 
}
