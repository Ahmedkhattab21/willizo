part of 'recipes_cubit.dart';

enum RecipesLoadStatus { initial, loading, success, failure }

final class RecipesState {
  final RecipesLoadStatus status;
  final List<RecipeModel> recipes;
  final List<String> tabs;
  final int selectedTabIndex;
  final bool isPopularGridView;
  final String? errorMessage;

  const RecipesState({
    required this.status,
    required this.recipes,
    required this.tabs,
    required this.selectedTabIndex,
    required this.isPopularGridView,
    this.errorMessage,
  });

  factory RecipesState.initial() {
    return const RecipesState(
      status: RecipesLoadStatus.initial,
      recipes: [],
      tabs: ['All'],
      selectedTabIndex: 0,
      isPopularGridView: true,
    );
  }

  String get selectedCategory {
    if (selectedTabIndex < 0 || selectedTabIndex >= tabs.length) return 'All';
    return tabs[selectedTabIndex];
  }

  List<RecipeModel> get featuredRecipes {
    return _recipesForSelectedCategory
        .where((recipe) => recipe.isFeatured)
        .toList();
  }

  List<RecipeModel> get popularRecipes {
    return _recipesForSelectedCategory
        .where((recipe) => recipe.isPopular)
        .toList();
  }

  List<RecipeModel> get _recipesForSelectedCategory {
    final activeRecipes = recipes.where((recipe) => recipe.isActive);
    if (selectedCategory.toLowerCase() == 'all') {
      return activeRecipes.toList();
    }

    return activeRecipes
        .where(
          (recipe) =>
              recipe.category.trim().toLowerCase() ==
              selectedCategory.trim().toLowerCase(),
        )
        .toList();
  }

  RecipesState copyWith({
    RecipesLoadStatus? status,
    List<RecipeModel>? recipes,
    List<String>? tabs,
    int? selectedTabIndex,
    bool? isPopularGridView,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RecipesState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      tabs: tabs ?? this.tabs,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isPopularGridView: isPopularGridView ?? this.isPopularGridView,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
