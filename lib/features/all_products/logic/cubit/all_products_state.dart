part of 'all_products_cubit.dart';

sealed class AllProductsState {}

final class AllProductsInitial extends AllProductsState {}

final class AllProductsLoadingState extends AllProductsState {}

final class AllProductsLoadedState extends AllProductsState {
  final AllProductsResponseModel allProductsData;

  AllProductsLoadedState({required this.allProductsData});
}

final class AllProductsErrorState extends AllProductsState {
  final String message;

  AllProductsErrorState({required this.message});
}
