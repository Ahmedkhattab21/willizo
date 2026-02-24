import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({ required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
  });

  factory ServerFailure.fromJson(Map<String, dynamic> json) {
    final m = json["message"];
    final String message = m == null
        ? 'Unknown error'
        : (m is String ? m : m.toString());
    return ServerFailure(message: message);
  }
}

