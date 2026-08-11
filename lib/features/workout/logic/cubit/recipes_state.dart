part of 'recipes_cubit.dart';

enum RecipesLoadStatus { initial, loading, success, failure }

final class RecipesState {
  final RecipesLoadStatus status;
  final List<RecipeModel> recipes;
  final List<String> tabs;
  final int selectedTabIndex;
  final bool isPopularGridView;
  final String searchQuery;
  final String? errorMessage;

  const RecipesState({
    required this.status,
    required this.recipes,
    required this.tabs,
    required this.selectedTabIndex,
    required this.isPopularGridView,
    required this.searchQuery,
    this.errorMessage,
  });

  factory RecipesState.initial() {
    return const RecipesState(
      status: RecipesLoadStatus.initial,
      recipes: [],
      tabs: ['All'],
      selectedTabIndex: 0,
      isPopularGridView: true,
      searchQuery: '',
    );
  }

  bool get isSearching => searchQuery.trim().isNotEmpty;

  String get selectedCategory {
    if (selectedTabIndex < 0 || selectedTabIndex >= tabs.length) return 'All';
    return tabs[selectedTabIndex];
  }

  List<RecipeModel> get featuredRecipes {
    return _filteredRecipes.where((recipe) => recipe.isFeatured).toList();
  }

  List<RecipeModel> get popularRecipes {
    return _filteredRecipes.where((recipe) => recipe.isPopular).toList();
  }

  List<RecipeModel> get searchResults => _filteredRecipes;

  List<RecipeModel> get _filteredRecipes {
    final query = searchQuery.trim().toLowerCase();
    final source = _recipesForSelectedCategory;
    if (query.isEmpty) return source;
    return source
        .where(
          (recipe) =>
              recipe.name.toLowerCase().contains(query) ||
              recipe.description.toLowerCase().contains(query) ||
              recipe.category.toLowerCase().contains(query),
        )
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
    String? searchQuery,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RecipesState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      tabs: tabs ?? this.tabs,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isPopularGridView: isPopularGridView ?? this.isPopularGridView,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
