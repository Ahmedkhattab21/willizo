part of 'categories_cubit.dart';

sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesLoadingState extends CategoriesState {}

final class CategoriesLoadedState extends CategoriesState {
  final CategoriesResponseModel categoriesData;

  CategoriesLoadedState({required this.categoriesData});
}

final class CategoriesErrorState extends CategoriesState {
  final String message;

  CategoriesErrorState({required this.message});
}
