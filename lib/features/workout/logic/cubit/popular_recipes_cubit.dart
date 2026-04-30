import 'package:bloc/bloc.dart';
import 'package:willizo/features/workout/data/models/recipes_response_model.dart';
import 'package:willizo/features/workout/data/repo/recipes_repo.dart';

part 'popular_recipes_state.dart';

class PopularRecipesCubit extends Cubit<PopularRecipesState> {
  final RecipesRepo recipesRepo;

  PopularRecipesCubit(this.recipesRepo) : super(PopularRecipesState.initial());

  Future<void> fetchPopularRecipes() async {
    emit(
      state.copyWith(
        status: PopularRecipesLoadStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await recipesRepo.getPopularRecipes();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PopularRecipesLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (recipes) => emit(
        state.copyWith(
          status: PopularRecipesLoadStatus.success,
          recipes: recipes.where((recipe) => recipe.isActive).toList(),
          clearErrorMessage: true,
        ),
      ),
    );
  }
}
