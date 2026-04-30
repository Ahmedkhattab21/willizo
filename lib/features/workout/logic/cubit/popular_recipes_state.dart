part of 'popular_recipes_cubit.dart';

enum PopularRecipesLoadStatus { initial, loading, success, failure }

final class PopularRecipesState {
  final PopularRecipesLoadStatus status;
  final List<RecipeModel> recipes;
  final String? errorMessage;

  const PopularRecipesState({
    required this.status,
    required this.recipes,
    this.errorMessage,
  });

  factory PopularRecipesState.initial() {
    return const PopularRecipesState(
      status: PopularRecipesLoadStatus.initial,
      recipes: [],
    );
  }

  PopularRecipesState copyWith({
    PopularRecipesLoadStatus? status,
    List<RecipeModel>? recipes,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PopularRecipesState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}
