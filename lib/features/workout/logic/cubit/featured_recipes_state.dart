part of 'featured_recipes_cubit.dart';

enum FeaturedRecipesLoadStatus { initial, loading, success, failure }

final class FeaturedRecipesState {
  final FeaturedRecipesLoadStatus status;
  final List<RecipeModel> recipes;
  final String? errorMessage;

  const FeaturedRecipesState({
    required this.status,
    required this.recipes,
    this.errorMessage,
  });

  factory FeaturedRecipesState.initial() {
    return const FeaturedRecipesState(
      status: FeaturedRecipesLoadStatus.initial,
      recipes: [],
    );
  }

  FeaturedRecipesState copyWith({
    FeaturedRecipesLoadStatus? status,
    List<RecipeModel>? recipes,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return FeaturedRecipesState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}
