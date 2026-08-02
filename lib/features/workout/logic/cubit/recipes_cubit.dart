import 'package:bloc/bloc.dart';
import 'package:willizo/features/workout/data/models/recipes_response_model.dart';
import 'package:willizo/features/workout/data/repo/recipes_repo.dart';

part 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  final RecipesRepo recipesRepo;

  RecipesCubit(this.recipesRepo) : super(RecipesState.initial());

  Future<void> fetchRecipes() async {
    emit(
      state.copyWith(
        status: RecipesLoadStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await recipesRepo.getRecipes();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: RecipesLoadStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (data) {
        final tabs = _buildTabsFromRecipes(data.data);
        emit(
          state.copyWith(
            status: RecipesLoadStatus.success,
            recipes: data.data,
            tabs: tabs,
            selectedTabIndex: 0,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  void selectTab(int index) {
    if (index < 0 || index >= state.tabs.length) return;
    emit(state.copyWith(selectedTabIndex: index));
  }

  Future<void> retry() async {
    await fetchRecipes();
  }

  void togglePopularLayout() {
    emit(state.copyWith(isPopularGridView: !state.isPopularGridView));
  }

  List<String> _buildTabsFromRecipes(List<RecipeModel> recipes) {
    final set = <String>{};
    for (final recipe in recipes) {
      final category = recipe.category.trim();
      if (category.isNotEmpty) {
        set.add(_capitalize(category));
      }
    }

    final dynamicTabs = set.toList()..sort((a, b) => a.compareTo(b));
    return ['All', ...dynamicTabs];
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
