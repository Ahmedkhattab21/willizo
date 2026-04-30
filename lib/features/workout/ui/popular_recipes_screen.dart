import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/workout/data/models/recipes_response_model.dart';
import 'package:willizo/features/workout/logic/cubit/popular_recipes_cubit.dart';
import 'package:willizo/features/workout/ui/widgets/recipe_card_widget.dart';

class PopularRecipesScreen extends StatelessWidget {
  const PopularRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        title: Text(
          'Popular Recipes',
          style: TextStyles.font18InterW600.copyWith(color: AppColors.whiteColor),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<PopularRecipesCubit, PopularRecipesState>(
          builder: (context, state) {
            if (state.status == PopularRecipesLoadStatus.loading ||
                state.status == PopularRecipesLoadStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            if (state.status == PopularRecipesLoadStatus.failure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? 'Failed to load popular recipes',
                      style: TextStyles.font14InterW400.copyWith(
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpace(10),
                    TextButton(
                      onPressed: () =>
                          context.read<PopularRecipesCubit>().fetchPopularRecipes(),
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
                  'No popular recipes found',
                  style: TextStyles.font14InterW400.copyWith(
                    color: AppColors.whiteColorEb,
                  ),
                ),
              );
            }

            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 0.72,
              ),
              itemCount: state.recipes.length,
              itemBuilder: (context, index) {
                return _PopularGridItem(recipe: state.recipes[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _PopularGridItem extends StatelessWidget {
  final RecipeModel recipe;

  const _PopularGridItem({required this.recipe});

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
          .take(3)
          .map((ingredient) => '${ingredient.amount} ${ingredient.name}'.trim())
          .toList(),
      showIngredients: false,
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
