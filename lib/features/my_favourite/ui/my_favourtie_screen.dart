import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/my_favourite/ui/widgets/favourite_card_widget.dart';
import 'package:willizo/features/shop/logic/cubit/badge_cubit.dart';
import 'package:willizo/features/workout/data/models/recipes_response_model.dart';
import 'package:willizo/features/workout/data/repo/recipes_repo.dart';
import 'package:willizo/features/workout/ui/recipe_details_screen.dart';
import 'package:willizo/features/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:willizo/features/wishlist/logic/cubit/wishlist_state.dart';

class MyFavouriteScreen extends StatefulWidget {
  const MyFavouriteScreen({super.key});

  @override
  State<MyFavouriteScreen> createState() => _MyFavouriteScreenState();
}

class _MyFavouriteScreenState extends State<MyFavouriteScreen> {
  int _selectedTabIndex = 0;
  late Future<_FavoriteMealsResult> _favoriteMealsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteMealsFuture = _loadFavoriteMeals();
  }

  Future<_FavoriteMealsResult> _loadFavoriteMeals() async {
    final response = await getIt<RecipesRepo>().getFavoriteRecipes();
    return response.fold(
      (failure) => _FavoriteMealsResult.error(failure.message),
      (recipes) => _FavoriteMealsResult.success(recipes),
    );
  }

  void _refreshMeals() {
    setState(() => _favoriteMealsFuture = _loadFavoriteMeals());
  }

  void _removeFavoriteMeal(RecipeModel recipe) {
    setState(() => _favoriteMealsFuture = _removeAndReloadFavoriteMeal(recipe));
  }

  Future<_FavoriteMealsResult> _removeAndReloadFavoriteMeal(
    RecipeModel recipe,
  ) async {
    if (recipe.slug.isEmpty) {
      return _FavoriteMealsResult.error('favorites.failedRemoveMeal'.tr());
    }

    final removeResult = await getIt<RecipesRepo>().toggleRecipeFavorite(
      recipe.slug,
    );
    return await removeResult.fold(
      (failure) async => _FavoriteMealsResult.error(failure.message),
      (_) => _loadFavoriteMeals(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: SvgPicture.asset(ImageAsset.arrowBackIcon),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "favorites.title".tr(),
                        style: TextStyles.font24InterW700.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
              child: _FavouriteTabs(
                selectedIndex: _selectedTabIndex,
                onChanged: (index) => setState(() => _selectedTabIndex = index),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: IndexedStack(
                  index: _selectedTabIndex,
                  children: [
                    const _ProductFavoritesBody(),
                    _MealFavoritesBody(
                      future: _favoriteMealsFuture,
                      onReload: _refreshMeals,
                      onRemoveFavorite: _removeFavoriteMeal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavouriteTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _FavouriteTabs({required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        color: AppColors.greyColor27,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _FavouriteTabButton(
            title: 'favorites.products'.tr(),
            isSelected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _FavouriteTabButton(
            title: 'favorites.meals'.tr(),
            isSelected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _FavouriteTabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FavouriteTabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(11.r),
          ),
          child: Text(
            title,
            style: TextStyles.font14BlackColorW700.copyWith(
              color: isSelected
                  ? AppColors.blackColor
                  : AppColors.greyColorColor80,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductFavoritesBody extends StatelessWidget {
  const _ProductFavoritesBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishlistCubit, WishlistState>(
      listener: (context, state) {
        if (state is WishlistLoaded) {
          getIt<BadgeCubit>().updateWishlistCount(
            state.wishlistData.data.length,
          );
        }
      },
      builder: (context, state) {
        if (state is WishlistLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (state is WishlistError) {
          return _FavouriteMessage(
            message: state.message,
            onRetry: () => context.read<WishlistCubit>().getWishlist(),
          );
        }

        if (state is WishlistLoaded) {
          final items = state.wishlistData.data;
          if (items.isEmpty) {
            return const _FavouriteMessage(
              messageKey: "favorites.emptyProducts",
            );
          }

          return GridView.builder(
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              final product = item.product;
              final isDeleting = state.isDeleting(product.id);

              return FavouriteCardWidget(
                image: product.displayImage,
                title: product.name,
                price: product.price,
                rating: product.averageRating.toStringAsFixed(1),
                isOnSale: product.comparePrice != null,
                isDeleting: isDeleting,
                onDelete: () => context
                    .read<WishlistCubit>()
                    .removeFromWishlist(product.id),
                onTap: () => context.pushNamed(
                  Routes.productDetailsScreen,
                  arguments: {'productId': product.id},
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _MealFavoritesBody extends StatelessWidget {
  final Future<_FavoriteMealsResult> future;
  final VoidCallback onReload;
  final ValueChanged<RecipeModel> onRemoveFavorite;

  const _MealFavoritesBody({
    required this.future,
    required this.onReload,
    required this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_FavoriteMealsResult>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final result = snapshot.data;
        if (result == null || result.errorMessage != null) {
          return _FavouriteMessage(
            message: result?.errorMessage ?? '',
            messageKey: result?.errorMessage == null
                ? 'favorites.failedMeals'
                : null,
            onRetry: onReload,
          );
        }

        final recipes = result.recipes;
        if (recipes.isEmpty) {
          return const _FavouriteMessage(messageKey: 'favorites.emptyMeals');
        }

        return GridView.builder(
          itemCount: recipes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return _MealFavouriteCard(
              recipe: recipes[index],
              onRemoveFavorite: onRemoveFavorite,
            );
          },
        );
      },
    );
  }
}

class _MealFavouriteCard extends StatefulWidget {
  final RecipeModel recipe;
  final ValueChanged<RecipeModel> onRemoveFavorite;

  const _MealFavouriteCard({
    required this.recipe,
    required this.onRemoveFavorite,
  });

  @override
  State<_MealFavouriteCard> createState() => _MealFavouriteCardState();
}

class _MealFavouriteCardState extends State<_MealFavouriteCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecipeDetailsScreen(recipe: widget.recipe),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.blackColor,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: widget.recipe.imageUrl.startsWith('http')
                    ? Image.network(
                        widget.recipe.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallbackImage(),
                      )
                    : _fallbackImage(),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.recipe.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.font18WhiteColor700.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        horizontalSpace(4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.orangeColorEA,
                              size: 16.sp,
                            ),
                            horizontalSpace(3),
                            Text(
                              widget.recipe.rating,
                              style: TextStyles.font14whiteColorColorW400
                                  .copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${widget.recipe.calories} cal',
                            style: TextStyles.font18WhiteColor700.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => widget.onRemoveFavorite(widget.recipe),
                          child: SvgPicture.asset(
                            ImageAsset.deleteIcon,
                            width: 20.w,
                            height: 20.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      ImageAsset.backgroundCardImage,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

class _FavoriteMealsResult {
  final List<RecipeModel> recipes;
  final String? errorMessage;

  const _FavoriteMealsResult._({required this.recipes, this.errorMessage});

  factory _FavoriteMealsResult.success(List<RecipeModel> recipes) {
    return _FavoriteMealsResult._(recipes: recipes);
  }

  factory _FavoriteMealsResult.error(String message) {
    return _FavoriteMealsResult._(recipes: const [], errorMessage: message);
  }
}

class _FavouriteMessage extends StatelessWidget {
  final String message;
  final String? messageKey;
  final VoidCallback? onRetry;

  const _FavouriteMessage({this.message = '', this.messageKey, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              messageKey?.tr() ?? message,
              textAlign: TextAlign.center,
              style: TextStyles.font16WhiteColorW400,
            ),
            if (onRetry != null) ...[
              verticalSpace(16),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.blackColor,
                ),
                child: Text("common.retry".tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
