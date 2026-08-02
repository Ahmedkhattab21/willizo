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
import 'package:willizo/features/workout/ui/widgets/recipe_card_widget.dart';
import 'package:willizo/features/workout/ui/widgets/recipe_tab_item.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  Widget _buildBody(BuildContext context, RecipesState state) {
    if (state.status == RecipesLoadStatus.loading ||
        state.status == RecipesLoadStatus.initial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (state.status == RecipesLoadStatus.failure) {
      return Center(
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
      );
    }

    final featuredRecipes = state.featuredRecipes;
    final popularRecipes = state.popularRecipes;
    final hasData = featuredRecipes.isNotEmpty || popularRecipes.isNotEmpty;

    if (!hasData) {
      return Center(
        child: Text(
          'No recipes for this category',
          style: TextStyles.font14InterW400.copyWith(
            color: AppColors.whiteColorEb,
          ),
        ),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
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
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: AppColors.greyColor2727,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: AppColors.greyColorCA,
                  size: 21.r,
                ),
                horizontalSpace(8),
                Text(
                  'Search recipes...',
                  style: TextStyles.font14InterW400.copyWith(
                    color: AppColors.greyColorCA,
                  ),
                ),
              ],
            ),
          ),
        ),
        horizontalSpace(10),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const _RecipeFiltersSheet(),
            );
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: AppColors.greyColor2727,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: AppColors.primaryColor,
              size: 20.r,
            ),
          ),
        ),
      ],
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
              _buildSearchBar(context),
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

class _RecipeFiltersSheet extends StatefulWidget {
  const _RecipeFiltersSheet();

  @override
  State<_RecipeFiltersSheet> createState() => _RecipeFiltersSheetState();
}

class _RecipeFiltersSheetState extends State<_RecipeFiltersSheet> {
  String _mealType = 'Breakfast';
  final Set<String> _dietaryNeeds = {'High Protein', 'High Fiber'};
  final Set<String> _prepTimes = {'< 15 min', '< 30 min'};
  final Set<String> _fitnessGoals = {'Muscle Gain', 'Post-Workout'};
  RangeValues _protein = const RangeValues(30, 70);
  RangeValues _carbs = const RangeValues(20, 50);
  RangeValues _fats = const RangeValues(15, 30);
  RangeValues _calories = const RangeValues(400, 800);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: SafeArea(
            top: false,
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
              children: [
                Center(
                  child: Container(
                    width: 42.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor3d,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
                verticalSpace(18),
                _FilterSectionTitle('Meal Type'),
                verticalSpace(14),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: ['Breakfast', 'Lunch', 'Dinner', 'Snack']
                      .map(
                        (item) => _FilterChipButton(
                          label: item,
                          selected: _mealType == item,
                          onTap: () => setState(() => _mealType = item),
                        ),
                      )
                      .toList(),
                ),
                verticalSpace(30),
                _FilterSectionTitle('Dietary Needs'),
                verticalSpace(14),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children:
                      [
                            'High Protein',
                            'Low Carb',
                            'Keto',
                            'High Fiber',
                            'Gluten-Free',
                            'Dairy-Free',
                            'Vegan',
                            'Vegetarian',
                            'Paleo',
                            'Low Fat',
                            'Grain-Free',
                            'Sugar-Free',
                          ]
                          .map(
                            (item) => _FilterChipButton(
                              label: item,
                              selected: _dietaryNeeds.contains(item),
                              wide: true,
                              onTap: () =>
                                  setState(() => _toggle(_dietaryNeeds, item)),
                            ),
                          )
                          .toList(),
                ),
                verticalSpace(32),
                _FilterSectionTitle('Macros & Calories'),
                verticalSpace(14),
                _FilterRangeSlider(
                  label: 'Protein (g)',
                  valueLabel:
                      '${_protein.start.round()} - ${_protein.end.round()}g',
                  values: _protein,
                  min: 0,
                  max: 100,
                  onChanged: (value) => setState(() => _protein = value),
                ),
                _FilterRangeSlider(
                  label: 'Carbs (g)',
                  valueLabel:
                      '${_carbs.start.round()} - ${_carbs.end.round()}g',
                  values: _carbs,
                  min: 0,
                  max: 100,
                  onChanged: (value) => setState(() => _carbs = value),
                ),
                _FilterRangeSlider(
                  label: 'Fats (g)',
                  valueLabel: '${_fats.start.round()} - ${_fats.end.round()}g',
                  values: _fats,
                  min: 0,
                  max: 60,
                  onChanged: (value) => setState(() => _fats = value),
                ),
                _FilterRangeSlider(
                  label: 'Calories (kcal)',
                  valueLabel:
                      '${_calories.start.round()} - ${_calories.end.round()}kcal',
                  values: _calories,
                  min: 0,
                  max: 1200,
                  onChanged: (value) => setState(() => _calories = value),
                ),
                verticalSpace(16),
                _FilterSectionTitle('Prep Time'),
                verticalSpace(14),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 10.h,
                  children: ['< 15 min', '< 30 min', '< 60 min', 'No limit']
                      .map(
                        (item) => _FilterChipButton(
                          label: item,
                          selected: _prepTimes.contains(item),
                          onTap: () =>
                              setState(() => _toggle(_prepTimes, item)),
                        ),
                      )
                      .toList(),
                ),
                verticalSpace(32),
                _FilterSectionTitle('Fitness Goals'),
                verticalSpace(14),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children:
                      [
                            'Muscle Gain',
                            'Post-Workout',
                            'Fat Loss',
                            'Anabolic',
                            'High Volume',
                            'Refeed Day',
                          ]
                          .map(
                            (item) => _FilterChipButton(
                              label: item,
                              selected: _fitnessGoals.contains(item),
                              onTap: () =>
                                  setState(() => _toggle(_fitnessGoals, item)),
                            ),
                          )
                          .toList(),
                ),
                verticalSpace(42),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.28),
                          blurRadius: 22,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Show Recipes',
                      style: TextStyles.font18InterW600.copyWith(
                        color: AppColors.blackColor,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggle(Set<String> values, String value) {
    if (values.contains(value)) {
      values.remove(value);
    } else {
      values.add(value);
    }
  }
}

class _FilterSectionTitle extends StatelessWidget {
  final String title;

  const _FilterSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyles.font18InterW600.copyWith(
        color: AppColors.whiteColorEb,
        fontSize: 21.sp,
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final bool wide;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: wide ? 120.w : null,
        constraints: BoxConstraints(minWidth: wide ? 120.w : 0),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : AppColors.greyColor2727,
          borderRadius: BorderRadius.circular(18.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyles.font18InterW600.copyWith(
            color: selected ? AppColors.blackColor : AppColors.greyColor75,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}

class _FilterRangeSlider extends StatelessWidget {
  final String label;
  final String valueLabel;
  final RangeValues values;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  const _FilterRangeSlider({
    required this.label,
    required this.valueLabel,
    required this.values,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyles.font18InterW600.copyWith(
                  color: AppColors.whiteColorEb,
                  fontSize: 17.sp,
                ),
              ),
              const Spacer(),
              Text(
                valueLabel,
                style: TextStyles.font18InterW600.copyWith(
                  color: AppColors.greyColor75,
                  fontSize: 17.sp,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primaryColor,
              inactiveTrackColor: AppColors.greyColor3d,
              rangeThumbShape: RoundRangeSliderThumbShape(
                enabledThumbRadius: 10.r,
              ),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
              trackHeight: 3.h,
              thumbColor: AppColors.whiteColorEb,
              overlayColor: AppColors.primaryColor.withValues(alpha: 0.15),
            ),
            child: RangeSlider(
              values: values,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
