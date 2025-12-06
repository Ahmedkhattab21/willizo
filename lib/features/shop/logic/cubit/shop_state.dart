part of 'shop_cubit.dart';

sealed class ShopState {}

final class ShopInitial extends ShopState {}

final class FetchShopLoadingState extends ShopState {}

final class FetchShopLoadedState extends ShopState {
  final ShopResponseModel shopData;

  FetchShopLoadedState({required this.shopData});
}

final class FetchShopErrorState extends ShopState {
  final String message;

  FetchShopErrorState({required this.message});
}
