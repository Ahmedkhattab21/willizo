part of 'related_products_cubit.dart';

sealed class RelatedProductsState {}

final class RelatedProductsInitial extends RelatedProductsState {}

final class RelatedProductsLoadingState extends RelatedProductsState {}

final class RelatedProductsLoadedState extends RelatedProductsState {
  final ShopResponseModel relatedProductsData;

  RelatedProductsLoadedState({required this.relatedProductsData});
}

final class RelatedProductsErrorState extends RelatedProductsState {
  final String message;

  RelatedProductsErrorState({required this.message});
}
