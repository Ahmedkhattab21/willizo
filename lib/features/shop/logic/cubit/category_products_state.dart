part of 'category_products_cubit.dart';

sealed class CategoryProductsState {}

final class CategoryProductsInitial extends CategoryProductsState {}

final class CategoryProductsLoadingState extends CategoryProductsState {}

final class CategoryProductsLoadedState extends CategoryProductsState {
  final AllProductsResponseModel categoryProductsData;

  CategoryProductsLoadedState({required this.categoryProductsData});
}

final class CategoryProductsErrorState extends CategoryProductsState {
  final String message;

  CategoryProductsErrorState({required this.message});
}
