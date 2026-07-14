part of 'checkout_cubit.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutAddressesLoaded extends CheckoutState {
  final List<AddressModel> addresses;

  const CheckoutAddressesLoaded({required this.addresses});

  @override
  List<Object> get props => [addresses];
}

final class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError({required this.message});

  @override
  List<Object> get props => [message];
}

final class CheckoutAddressCreated extends CheckoutState {
  final AddressModel address;

  const CheckoutAddressCreated({required this.address});

  @override
  List<Object> get props => [address];
}

final class CheckoutCalculationLoaded extends CheckoutState {
  final CheckoutCalculationResponseModel calculation;

  const CheckoutCalculationLoaded({required this.calculation});

  @override
  List<Object> get props => [calculation];
}

final class CheckoutOrderConfirmed extends CheckoutState {
  final OrderResponseModel orderResponse;

  const CheckoutOrderConfirmed({required this.orderResponse});

  OrderModel get order => orderResponse.order;

  @override
  List<Object> get props => [orderResponse];
}
