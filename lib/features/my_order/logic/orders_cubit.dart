import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:willizo/features/my_order/data/models/orders_response_model.dart';
import 'package:willizo/features/my_order/data/repos/orders_repo.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo ordersRepo;

  OrdersCubit(this.ordersRepo) : super(OrdersInitial());

  Future<void> getOrders() async {
    emit(OrdersLoading());
    final result = await ordersRepo.getOrders();
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (response) => emit(OrdersLoaded(response.data)),
    );
  }

  Future<void> getOrderDetails(String orderId) async {
    emit(OrderDetailsLoading());
    final result = await ordersRepo.getOrderDetails(orderId);
    result.fold(
      (failure) => emit(OrderDetailsError(failure.message)),
      (response) => emit(OrderDetailsLoaded(response.data)),
    );
  }
}
