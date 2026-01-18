import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:willizo/features/checkout/data/models/address_model.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_request_model.dart';
import 'package:willizo/features/checkout/data/models/checkout_calculation_response_model.dart';
import 'package:willizo/features/checkout/data/models/create_address_request_model.dart';
import 'package:willizo/features/checkout/data/models/order_response_model.dart';
import 'package:willizo/features/checkout/data/repos/checkout_repo.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutRepo checkoutRepo;

  CheckoutCubit(this.checkoutRepo) : super(CheckoutInitial());

  Future<void> getAddresses() async {
    emit(CheckoutLoading());
    final result = await checkoutRepo.getAddresses();
    result.fold(
      (failure) => emit(CheckoutError(message: failure.message)),
      (addressResponse) =>
          emit(CheckoutAddressesLoaded(addresses: addressResponse.data)),
    );
  }

  Future<void> createAddress(CreateAddressRequestModel request) async {
    emit(CheckoutLoading());
    final result = await checkoutRepo.createAddress(request);
    result.fold((failure) => emit(CheckoutError(message: failure.message)), (
      createResponse,
    ) async {
      // Emit success state first
      emit(CheckoutAddressCreated(address: createResponse.address));
      // Then fetch addresses again to update the list
      await getAddresses();
    });
  }

  Future<void> calculateCheckout(String addressId, {String? couponCode}) async {
    emit(CheckoutLoading());
    final request = CheckoutCalculationRequestModel(
      addressId: addressId,
      couponCode: couponCode,
    );
    final result = await checkoutRepo.calculateCheckout(request);
    result.fold(
      (failure) => emit(CheckoutError(message: failure.message)),
      (calculationResponse) => emit(
        CheckoutCalculationLoaded(calculation: calculationResponse),
      ),
    );
  }

  Future<void> confirmCheckout() async {
    emit(CheckoutLoading());
    final result = await checkoutRepo.confirmCheckout();
    result.fold(
      (failure) => emit(CheckoutError(message: failure.message)),
      (orderResponse) => emit(
        CheckoutOrderConfirmed(order: orderResponse.order),
      ),
    );
  }
}
