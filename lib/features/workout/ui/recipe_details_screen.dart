import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/workout/data/models/recipes_response_model.dart';
import 'package:willizo/features/workout/data/repo/recipes_repo.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late RecipeModel _recipe = widget.recipe;
  bool _isLoading = true;
  bool _isAdding = false;
  bool _isFavoriteLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final result = await getIt<RecipesRepo>().getRecipeDetails(
      widget.recipe.slug,
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _isLoading = false;
      }),
      (recipe) => setState(() {
        _recipe = recipe;
        _isLoading = false;
      }),
    );
  }

  Future<void> _addToMealPlan() async {
    if (_isAdding) return;
    setState(() => _isAdding = true);
    final today = DateTime.now();
    final date =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final result = await getIt<RecipesRepo>().addRecipeToMealPlan(
      recipeId: _recipe.id,
      mealType: _recipe.category.isNotEmpty ? _recipe.category : 'breakfast',
      plannedDate: date,
    );
    if (!mounted) return;
    setState(() => _isAdding = false);
    result.fold(
      (failure) => AppConstant.toast(failure.message, AppColors.redColor),
      (_) => AppConstant.toast(
        'Recipe added to meal plan',
        AppColors.primaryColor,
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    if (_isFavoriteLoading || _recipe.slug.isEmpty) return;
    setState(() => _isFavoriteLoading = true);
    final nextValue = !_recipe.isFavorited;
    final result = await getIt<RecipesRepo>().toggleRecipeFavorite(
      _recipe.slug,
    );
    if (!mounted) return;
    setState(() => _isFavoriteLoading = false);
    result.fold(
      (failure) => AppConstant.toast(failure.message, AppColors.redColor),
      (_) {
        setState(() => _recipe = _recipe.copyWith(isFavorited: nextValue));
        AppConstant.toast(
          nextValue
              ? 'Recipe added to favorite'
              : 'Recipe removed from favorite',
          AppColors.primaryColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyColor20,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _HeroImage(recipe: _recipe)),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: Offset(0, -24.h),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16.w, 34.h, 16.w, 116.h),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor20,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(22.r),
                      ),
                    ),
                    child: _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 48.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        : _error != null
                        ? _ErrorBox(message: _error!, onRetry: _loadDetails)
                        : _DetailsContent(recipe: _recipe),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 16.w,
            top: MediaQuery.of(context).padding.top + 12.h,
            child: _CircleIconButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            right: 16.w,
            top: MediaQuery.of(context).padding.top + 12.h,
            child: _CircleIconButton(
              icon: _recipe.isFavorited
                  ? Icons.favorite
                  : Icons.favorite_border,
              iconColor: _recipe.isFavorited
                  ? AppColors.primaryColor
                  : AppColors.whiteColor,
              isLoading: _isFavoriteLoading,
              onTap: _toggleFavorite,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                decoration: BoxDecoration(
                  color: AppColors.greyColor20,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.greyColor3d.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _isLoading ? null : _addToMealPlan,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          height: 54.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: _isAdding
                              ? const CircularProgressIndicator(
                                  color: AppColors.blackColor,
                                )
                              : Text(
                                  'Add to Meal Plan',
                                  style: TextStyles.font16WhiteColorW600
                                      .copyWith(color: AppColors.blackColor),
                                ),
                        ),
                      ),
                    ),
                    horizontalSpace(12),
                    _ShareButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final RecipeModel recipe;

  const _DetailsContent({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final instructions = recipe.instructions.isNotEmpty
        ? recipe.instructions
        : [
            RecipeInstructionModel(
              step: 1,
              title: 'Prepare the meal',
              description: recipe.description,
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.name,
          style: TextStyles.font18InterW600.copyWith(
            color: AppColors.whiteColor,
            fontSize: 22.sp,
          ),
        ),
        verticalSpace(10),
        _StatsRow(recipe: recipe),
        verticalSpace(18),
        _MacrosRow(recipe: recipe),
        verticalSpace(22),
        Text(
          recipe.description,
          style: TextStyles.font14InterW400.copyWith(
            color: AppColors.greyColorD1,
            height: 1.55,
          ),
        ),
        verticalSpace(26),
        _SectionTitle('Ingredients'),
        verticalSpace(12),
        ...recipe.ingredients.map((item) => _IngredientRow(item: item)),
        verticalSpace(22),
        _SectionTitle('Instructions'),
        verticalSpace(14),
        ...instructions.asMap().entries.map(
          (entry) => _InstructionStep(
            isLast: entry.key == instructions.length - 1,
            instruction: entry.value,
          ),
        ),
        verticalSpace(22),
        _TipsCard(tips: recipe.proTips),
        verticalSpace(20),
        _BestTimesCard(times: recipe.bestTimes, category: recipe.category),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  final RecipeModel recipe;

  const _HeroImage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 278.h,
      child: recipe.imageUrl.isEmpty
          ? Container(color: AppColors.greyColor2727)
          : CachedNetworkImage(
              imageUrl: recipe.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                color: AppColors.greyColor2727,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final RecipeModel recipe;

  const _StatsRow({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14.w,
      runSpacing: 8.h,
      children: [
        _StatItem(
          icon: Icons.access_time_filled_rounded,
          text: '${recipe.totalTime} mins',
          color: AppColors.greenColor12,
        ),
        _StatItem(
          icon: Icons.local_fire_department_rounded,
          text: '${recipe.calories} kcal',
          color: AppColors.orangeColorE9,
        ),
        _StatItem(
          icon: Icons.star_rounded,
          text: recipe.reviewCount > 0
              ? '${recipe.rating} (${recipe.reviewCount})'
              : recipe.rating,
          color: AppColors.yellowColorF7,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 15.r),
        horizontalSpace(4),
        Text(
          text,
          style: TextStyles.font12InterWhiteW400.copyWith(
            color: AppColors.greyColorD1,
          ),
        ),
      ],
    );
  }
}

class _MacrosRow extends StatelessWidget {
  final RecipeModel recipe;

  const _MacrosRow({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _MacroText(
          label: 'Protein',
          value: '${recipe.protein}g',
          color: AppColors.greenColor12,
        ),
        _MacroText(
          label: 'Carbs',
          value: '${recipe.carbs}g',
          color: AppColors.blueColorF9,
        ),
        _MacroText(
          label: 'Fat',
          value: '${recipe.fat}g',
          color: AppColors.yellowColorF7,
        ),
        _MacroText(
          label: 'Fiber',
          value: '${recipe.fiber}g',
          color: AppColors.purbleColorFA,
        ),
      ],
    );
  }
}

class _MacroText extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroText({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyles.font18InterW600.copyWith(
            color: color,
            fontSize: 22.sp,
          ),
        ),
        verticalSpace(2),
        Text(
          label,
          style: TextStyles.font12InterWhiteW400.copyWith(
            color: AppColors.greyColor75,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyles.font16WhiteColorW600.copyWith(fontSize: 17.sp),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final RecipeIngredientModel item;

  const _IngredientRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Container(
            width: 7.w,
            height: 7.w,
            decoration: const BoxDecoration(
              color: AppColors.greenColor12,
              shape: BoxShape.circle,
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Text(
              item.name,
              style: TextStyles.font14InterW400.copyWith(
                color: AppColors.greyColorD1,
              ),
            ),
          ),
          Text(
            item.amount,
            style: TextStyles.font12InterWhiteW400.copyWith(
              color: AppColors.greyColor75,
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final RecipeInstructionModel instruction;
  final bool isLast;

  const _InstructionStep({required this.instruction, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final step = instruction.step == 0 ? 1 : instruction.step;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text('$step', style: TextStyles.font14BlackColorW700),
            ),
            if (!isLast)
              Container(width: 1.w, height: 86.h, color: AppColors.greyColor3d),
          ],
        ),
        horizontalSpace(14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instruction.title.isEmpty ? 'Step $step' : instruction.title,
                  style: TextStyles.font14InterW600.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                verticalSpace(8),
                Text(
                  instruction.description,
                  style: TextStyles.font12InterWhiteW400.copyWith(
                    color: AppColors.greyColorD1,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TipsCard extends StatelessWidget {
  final List<String> tips;

  const _TipsCard({required this.tips});

  @override
  Widget build(BuildContext context) {
    final items = tips.isEmpty
        ? ['Meal prep friendly', 'Perfect balanced meal']
        : tips;
    return _InfoCard(
      title: 'Pro Tips',
      icon: Icons.lightbulb,
      children: items
          .map(
            (tip) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, color: AppColors.greenColor12, size: 17.r),
                  horizontalSpace(8),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyles.font14InterW400.copyWith(
                        color: AppColors.greyColorD1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _BestTimesCard extends StatelessWidget {
  final List<RecipeBestTimeModel> times;
  final String category;

  const _BestTimesCard({required this.times, required this.category});

  @override
  Widget build(BuildContext context) {
    final items = times.isEmpty
        ? [
            RecipeBestTimeModel(
              label: category.isEmpty ? 'Post-Workout' : category,
              status: 'Recommended',
            ),
            const RecipeBestTimeModel(label: 'Lunch', status: 'Good'),
            const RecipeBestTimeModel(label: 'Dinner', status: 'Good'),
          ]
        : times;
    return _InfoCard(
      title: 'Best Times to Eat',
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: AppColors.greyColor,
                    child: Icon(
                      Icons.restaurant,
                      size: 16.r,
                      color: AppColors.orangeColorE9,
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyles.font14InterW400.copyWith(
                        color: AppColors.greyColorD1,
                      ),
                    ),
                  ),
                  Text(
                    item.status,
                    style: TextStyles.font14InterW400.copyWith(
                      color: item.status.toLowerCase().contains('recommend')
                          ? AppColors.greenColor12
                          : AppColors.greyColor75,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.blackColor171C,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor3d),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.yellowColorF7, size: 18.r),
                horizontalSpace(8),
              ],
              _SectionTitle(title),
            ],
          ),
          verticalSpace(14),
          ...children,
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final bool isLoading;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.whiteColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: AppColors.greyColor75.withValues(alpha: 0.7),
        child: isLoading
            ? SizedBox(
                width: 16.r,
                height: 16.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryColor,
                ),
              )
            : Icon(icon, color: iconColor, size: 20.r),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54.w,
      height: 54.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Icon(Icons.share, color: AppColors.primaryColor, size: 22.r),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message,
          style: TextStyles.font14InterW400.copyWith(color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
        verticalSpace(10),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}
