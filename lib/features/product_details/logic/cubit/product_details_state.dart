part of 'product_details_cubit.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoadingState extends ProductDetailsState {}

class ProductDetailsLoadedState extends ProductDetailsState {
  final ProductDetailsResponseModel productDetails;

  ProductDetailsLoadedState({required this.productDetails});
}

class ProductDetailsErrorState extends ProductDetailsState {
  final String message;

  ProductDetailsErrorState({required this.message});
}

class AddToCartLoadingState extends ProductDetailsState {}

class AddToCartSuccessState extends ProductDetailsState {
  final ProductAddedToCartResponse response;

  AddToCartSuccessState({required this.response});
}

class AddToCartErrorState extends ProductDetailsState {
  final String message;

  AddToCartErrorState({required this.message});
}

class AddProductToWishlistLoadingState extends ProductDetailsState {}

class AddProductToWishlistSuccessState extends ProductDetailsState {
  final AddProductToWishlistResponse response;

  AddProductToWishlistSuccessState({required this.response});
}

class AddProductToWishlistErrorState extends ProductDetailsState {
  final String message;

  AddProductToWishlistErrorState({required this.message});
}

class RemoveFromWishlistLoadingState extends ProductDetailsState {}

class RemoveFromWishlistSuccessState extends ProductDetailsState {}

class RemoveFromWishlistErrorState extends ProductDetailsState {
  final String message;

  RemoveFromWishlistErrorState({required this.message});
}