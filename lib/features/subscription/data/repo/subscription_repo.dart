import 'package:dartz/dartz.dart';
import 'package:willizo/core/exceptions/exceptions.dart';
import 'package:willizo/core/exceptions/failure.dart';
import 'package:willizo/features/subscription/data/models/subscription_models.dart';
import 'package:willizo/features/subscription/data/services/subscription_service.dart';

class SubscriptionRepo {
  final SubscriptionService service;

  SubscriptionRepo(this.service);

  Future<Either<Failure, CurrentSubscriptionResponse>>
  getCurrentSubscription() async {
    try {
      return Right(await service.getCurrentSubscription());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, PlansResponse>> getPlans() async {
    try {
      return Right(await service.getPlans());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, MembersResponse>> getMembers() async {
    try {
      return Right(await service.getMembers());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, PaymentsResponse>> getPaymentHistory() async {
    try {
      return Right(await service.getPaymentHistory());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, UpcomingPaymentResponse>> getUpcomingPayment() async {
    try {
      return Right(await service.getUpcomingPayment());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, SubscriptionPaymentModel>> getPayment(
    String id,
  ) async {
    try {
      return Right(await service.getPayment(id));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, String>> inviteMember(String email) async {
    try {
      return Right(await service.inviteMember(email));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, String>> changePlan(String planId) async {
    try {
      return Right(await service.changePlan(planId));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, String>> subscribe(String planId) async {
    try {
      return Right(await service.subscribe(planId));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, String>> toggleAutoRenew(bool autoRenew) async {
    try {
      return Right(await service.toggleAutoRenew(autoRenew));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, String>> cancelSubscription() async {
    try {
      return Right(await service.cancelSubscription());
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, String>> shareReceipt(
    String paymentId,
    String email,
  ) async {
    try {
      return Right(await service.shareReceipt(paymentId, email));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
