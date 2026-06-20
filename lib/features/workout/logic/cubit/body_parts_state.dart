part of 'body_parts_cubit.dart';

enum BodyPartsLoadStatus { initial, loading, success, failure }

final class BodyPartsState {
  final BodyPartsLoadStatus status;
  final List<BodyPartModel> groups;
  final String? errorMessage;

  const BodyPartsState({
    required this.status,
    required this.groups,
    this.errorMessage,
  });

  factory BodyPartsState.initial() {
    return const BodyPartsState(
      status: BodyPartsLoadStatus.initial,
      groups: [],
    );
  }

  BodyPartsState copyWith({
    BodyPartsLoadStatus? status,
    List<BodyPartModel>? groups,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BodyPartsState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}
