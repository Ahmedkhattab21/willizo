import 'package:bloc/bloc.dart';
import 'package:willizo/features/workout/data/models/recipes_response_model.dart';
import 'package:willizo/features/workout/data/repo/recipes_repo.dart';

part 'featured_recipes_state.dart';

class FeaturedRecipesCubit extends Cubit<FeaturedRecipesState> {
  final RecipesRepo recipesRepo;

  FeaturedRecipesCubit(this.recipesRepo) : super(FeaturedRecipesState.initial());

  Future<void> fetchFeaturedRecipes() async {
    emit(
      state.copyWith(
        status: FeaturedRecipesLoadStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await recipesRepo.getFeaturedRecipes();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FeaturedRecipesLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (recipes) => emit(
        state.copyWith(
          status: FeaturedRecipesLoadStatus.success,
          recipes: recipes.where((recipe) => recipe.isActive).toList(),
          clearErrorMessage: true,
        ),
      ),
    );
  }
}
