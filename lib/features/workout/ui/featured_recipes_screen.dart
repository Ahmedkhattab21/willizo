import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/workout/data/models/recipes_response_model.dart';
import 'package:willizo/features/workout/logic/cubit/featured_recipes_cubit.dart';
import 'package:willizo/features/workout/ui/recipe_details_screen.dart';
import 'package:willizo/features/workout/ui/widgets/recipe_card_widget.dart';

class FeaturedRecipesScreen extends StatelessWidget {
  const FeaturedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        title: Text(
          'Featured Recipes',
          style: TextStyles.font18InterW600.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<FeaturedRecipesCubit, FeaturedRecipesState>(
          builder: (context, state) {
            if (state.status == FeaturedRecipesLoadStatus.loading ||
                state.status == FeaturedRecipesLoadStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            if (state.status == FeaturedRecipesLoadStatus.failure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? 'Failed to load featured recipes',
                      style: TextStyles.font14InterW400.copyWith(
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpace(10),
                    TextButton(
                      onPressed: () => context
                          .read<FeaturedRecipesCubit>()
                          .fetchFeaturedRecipes(),
                      child: Text(
                        'Retry',
                        style: TextStyles.font14W700.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.recipes.isEmpty) {
              return Center(
                child: Text(
                  'No featured recipes found',
                  style: TextStyles.font14InterW400.copyWith(
                    color: AppColors.whiteColorEb,
                  ),
                ),
              );
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemBuilder: (context, index) =>
                  _FeaturedRecipeItem(recipe: state.recipes[index]),
              separatorBuilder: (_, __) => verticalSpace(14),
              itemCount: state.recipes.length,
            );
          },
        ),
      ),
    );
  }
}

class _FeaturedRecipeItem extends StatelessWidget {
  final RecipeModel recipe;

  const _FeaturedRecipeItem({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return RecipeCard(
      cardType: RecipeCardType.popular,
      name: recipe.name,
      imageUrl: recipe.imageUrl,
      calories: '${recipe.calories} cal',
      duration: '${recipe.totalTime} min',
      rating: recipe.rating,
      protein: '${recipe.protein}g Protein',
      category: _capitalize(recipe.category),
      ingredients: recipe.ingredients
          .take(5)
          .map((ingredient) => '${ingredient.amount} ${ingredient.name}'.trim())
          .toList(),
      onViewRecipe: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RecipeDetailsScreen(recipe: recipe)),
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
