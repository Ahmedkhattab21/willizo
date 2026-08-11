import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/workout/data/models/recipes_response_model.dart';
import 'package:willizo/features/workout/logic/cubit/featured_recipes_cubit.dart';
import 'package:willizo/features/workout/logic/cubit/recipes_cubit.dart';
import 'package:willizo/features/workout/ui/featured_recipes_screen.dart';
import 'package:willizo/features/workout/ui/recipe_details_screen.dart';
import 'package:willizo/features/workout/ui/widgets/recipe_card_widget.dart';
import 'package:willizo/features/workout/ui/widgets/recipe_tab_item.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  Widget _buildBody(BuildContext context, RecipesState state) {
    if (state.status == RecipesLoadStatus.loading ||
        state.status == RecipesLoadStatus.initial) {
      return const _RefreshableBody(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }

    if (state.status == RecipesLoadStatus.failure) {
      return _RefreshableBody(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.errorMessage ?? 'Failed to load recipes',
                style: TextStyles.font14InterW400.copyWith(
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpace(10),
              TextButton(
                onPressed: () => context.read<RecipesCubit>().retry(),
                child: Text(
                  'Retry',
                  style: TextStyles.font14W700.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final featuredRecipes = state.featuredRecipes;
    final popularRecipes = state.popularRecipes;
    final searchResults = state.searchResults;
    final hasData = featuredRecipes.isNotEmpty || popularRecipes.isNotEmpty;

    if (!hasData) {
      return _RefreshableBody(
        child: Center(
          child: Text(
            'No recipes for this category',
            style: TextStyles.font14InterW400.copyWith(
              color: AppColors.whiteColorEb,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryColor,
      backgroundColor: AppColors.greyColor2727,
      onRefresh: context.read<RecipesCubit>().fetchRecipes,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          if (state.isSearching) ...[
            _SectionHeader(
              title: 'Search results',
              trailingIcon: state.isPopularGridView
                  ? Icons.grid_view_rounded
                  : Icons.list_rounded,
              onTrailingTap: () =>
                  context.read<RecipesCubit>().togglePopularLayout(),
            ),
            verticalSpace(10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: state.isPopularGridView
                  ? _PopularRecipesGrid(
                      key: const ValueKey('search-recipes-grid'),
                      recipes: searchResults,
                    )
                  : Column(
                      key: const ValueKey('search-recipes-list'),
                      children: searchResults
                          .map(
                            (recipe) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _PopularRecipeCard(recipe: recipe),
                            ),
                          )
                          .toList(),
                    ),
            ),
            if (searchResults.isEmpty) const _SectionEmptyText(),
          ] else ...[
            _SectionHeader(
              title: 'Featured Recipes',
              trailingText: 'See All',
              onTrailingTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) =>
                          FeaturedRecipesCubit(getIt())..fetchFeaturedRecipes(),
                      child: const FeaturedRecipesScreen(),
                    ),
                  ),
                );
              },
            ),
            verticalSpace(10),
            ...featuredRecipes.map(
              (recipe) => Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: _FeaturedRecipeCard(recipe: recipe),
              ),
            ),
            if (featuredRecipes.isEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: _SectionEmptyText(),
              ),
            _SectionHeader(
              title: 'Popular Recipes',
              trailingIcon: state.isPopularGridView
                  ? Icons.grid_view_rounded
                  : Icons.list_rounded,
              onTrailingTap: () =>
                  context.read<RecipesCubit>().togglePopularLayout(),
            ),
            verticalSpace(10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: state.isPopularGridView
                  ? _PopularRecipesGrid(
                      key: const ValueKey('popular-recipes-grid'),
                      recipes: popularRecipes,
                    )
                  : Column(
                      key: const ValueKey('popular-recipes-list'),
                      children: popularRecipes
                          .map(
                            (recipe) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _PopularRecipeCard(recipe: recipe),
                            ),
                          )
                          .toList(),
                    ),
            ),
            if (popularRecipes.isEmpty) const _SectionEmptyText(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, RecipesState state) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.greyColor2727,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: AppColors.greyColorCA, size: 21.r),
          horizontalSpace(8),
          Expanded(
            child: TextField(
              onChanged: context.read<RecipesCubit>().updateSearchQuery,
              style: TextStyles.font14InterW400.copyWith(
                color: AppColors.whiteColor,
              ),
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                hintStyle: TextStyles.font14InterW400.copyWith(
                  color: AppColors.greyColorCA,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesCubit, RecipesState>(
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(context, state),
              verticalSpace(14),
              SizedBox(
                height: 31.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.tabs.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final isSelected = index == state.selectedTabIndex;
                    return RecipeTabItem(
                      label: state.tabs[index],
                      isSelected: isSelected,
                      onTap: () =>
                          context.read<RecipesCubit>().selectTab(index),
                    );
                  },
                ),
              ),
              verticalSpace(18),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildBody(context, state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailingText;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingTap;

  const _SectionHeader({
    required this.title,
    this.trailingIcon,
    this.trailingText,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyles.font18InterW600.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        const Spacer(),
        if (trailingText != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailingText!,
              style: TextStyles.font10InterW400.copyWith(
                color: AppColors.greenColor7,
              ),
            ),
          ),
        if (trailingText != null && trailingIcon != null) horizontalSpace(4),
        if (trailingIcon != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Icon(
              trailingIcon,
              size: 24.r,
              color: AppColors.primaryColor,
            ),
          ),
      ],
    );
  }
}

class _RefreshableBody extends StatelessWidget {
  final Widget child;

  const _RefreshableBody({required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryColor,
      backgroundColor: AppColors.greyColor2727,
      onRefresh: context.read<RecipesCubit>().fetchRecipes,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.55,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _FeaturedRecipeCard extends StatelessWidget {
  final RecipeModel recipe;

  const _FeaturedRecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return RecipeCard(
      cardType: RecipeCardType.featured,
      name: recipe.name,
      imageUrl: recipe.imageUrl,
      calories: '${recipe.calories} cal',
      duration: '${recipe.totalTime} min',
      rating: recipe.rating,
      onViewRecipe: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RecipeDetailsScreen(recipe: recipe)),
      ),
    );
  }
}

class _PopularRecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final bool compact;

  const _PopularRecipeCard({required this.recipe, this.compact = false});

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
      showIngredients: !compact,
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

class _PopularRecipesGrid extends StatelessWidget {
  final List<RecipeModel> recipes;

  const _PopularRecipesGrid({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1000
            ? 4
            : width >= 760
            ? 3
            : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            mainAxisExtent: 200.h,
          ),
          itemCount: recipes.length,
          itemBuilder: (context, index) =>
              _PopularRecipeCard(recipe: recipes[index], compact: true),
        );
      },
    );
  }
}

class _SectionEmptyText extends StatelessWidget {
  const _SectionEmptyText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'No recipes found',
      style: TextStyles.font12InterWhiteW400.copyWith(
        color: AppColors.greyColorCA,
      ),
    );
  }
}
