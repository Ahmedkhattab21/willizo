import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

enum RecipeCardType { featured, popular }

class RecipeCard extends StatelessWidget {
  final RecipeCardType cardType;
  final String name;
  final String imageUrl;
  final String calories;
  final String duration;
  final String rating;
  final String? protein;
  final String? category;
  final List<String> ingredients;
  final bool showIngredients;

  const RecipeCard({
    super.key,
    required this.cardType,
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.duration,
    required this.rating,
    this.protein,
    this.category,
    this.ingredients = const [],
    this.showIngredients = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.greyColor20,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: cardType == RecipeCardType.featured
          ? _FeaturedRecipeContent(
              name: name,
              imageUrl: imageUrl,
              calories: calories,
              duration: duration,
              rating: rating,
            )
          : _PopularRecipeContent(
              name: name,
              imageUrl: imageUrl,
              calories: calories,
              duration: duration,
              rating: rating,
              protein: protein ?? '0g Protein',
              category: category ?? 'Breakfast',
              ingredients: ingredients,
              showIngredients: showIngredients,
            ),
    );
  }
}

class _FeaturedRecipeContent extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String calories;
  final String duration;
  final String rating;

  const _FeaturedRecipeContent({
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.duration,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RecipeImage(imageUrl: imageUrl, height: 108.h),
        Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyles.font18InterW600.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
              verticalSpace(8),
              _RecipeStatsRow(
                duration: duration,
                calories: calories,
                rating: rating,
              ),
              verticalSpace(10),
              _RecipeCtaButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _PopularRecipeContent extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String calories;
  final String duration;
  final String rating;
  final String protein;
  final String category;
  final List<String> ingredients;
  final bool showIngredients;

  const _PopularRecipeContent({
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.duration,
    required this.rating,
    required this.protein,
    required this.category,
    required this.ingredients,
    required this.showIngredients,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = !showIngredients;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isCompact ? 8.w : 10.w,
        isCompact ? 8.h : 10.h,
        isCompact ? 8.w : 10.w,
        isCompact ? 0.h : 3.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _RecipeImage(
                imageUrl: imageUrl,
                height: isCompact ? 92.h : 126.h,
              ),
              if (!isCompact) ...[
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: _TopBadge(
                    label: calories,
                    backgroundColor: const Color(0xCC3A2A16),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: _TopBadge(
                    label: protein,
                    backgroundColor: const Color(0xCC23311F),
                  ),
                ),
              ] else
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: _TopBadge(
                    label: protein,
                    backgroundColor: const Color(0xCC23311F),
                  ),
                ),
            ],
          ),
          verticalSpace(isCompact ? 8 : 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  maxLines: isCompact ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font18InterW600.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 8.sp,
                  ),
                ),
              ),
              if (!isCompact)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greenColorAB,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    category,
                    style: TextStyles.font10InterW400.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          verticalSpace(isCompact ? 6 : 10),
          _RecipeStatsRow(
            duration: duration,
            calories: calories,
            rating: rating,
            compact: isCompact,
            showDuration: !isCompact,
          ),
          verticalSpace(isCompact ? 6 : 10),
          if (showIngredients) ...[
            Text(
              'Main Ingredients:',
              style: TextStyles.font14W600.copyWith(
                color: AppColors.whiteColor,
                fontSize: 13.sp,
              ),
            ),
            verticalSpace(6),
            ...ingredients.map(
              (ingredient) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  '• $ingredient',
                  style: TextStyles.font12InterWhiteW400,
                ),
              ),
            ),
            verticalSpace(10),
          ] else
            verticalSpace(4),
          _RecipeCtaButton(compact: isCompact),
        ],
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  final String imageUrl;
  final double height;

  const _RecipeImage({required this.imageUrl, required this.height});

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(14.r),
        topRight: Radius.circular(14.r),
      ),
      child: hasImage
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => _RecipeImageFallback(height: height),
              errorWidget: (_, __, ___) => _RecipeImageFallback(height: height),
            )
          : _RecipeImageFallback(height: height),
    );
  }
}

class _RecipeImageFallback extends StatelessWidget {
  final double height;

  const _RecipeImageFallback({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.greyColor2727,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.greyColorCA,
        size: 28.r,
      ),
    );
  }
}

class _RecipeStatsRow extends StatelessWidget {
  final String duration;
  final String calories;
  final String rating;
  final bool compact;
  final bool showDuration;

  const _RecipeStatsRow({
    required this.duration,
    required this.calories,
    required this.rating,
    this.compact = false,
    this.showDuration = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: compact ? 8.w : 12.w,
      runSpacing: 6.h,
      children: [
        if (showDuration)
          _StatText(
            icon: Icons.access_time_filled_rounded,
            text: duration,
            compact: compact,
          ),
        _StatText(
          icon: Icons.local_fire_department_rounded,
          text: calories,
          compact: compact,
        ),
        _StatText(icon: Icons.star_rounded, text: rating, compact: compact),
      ],
    );
  }
}

class _StatText extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool compact;

  const _StatText({
    required this.icon,
    required this.text,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = switch (icon) {
      Icons.local_fire_department_rounded => AppColors.orangeColorFA,
      Icons.star_rounded => AppColors.yellowColorF7,
      _ => AppColors.primaryColor,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: compact ? 12.r : 14.r, color: iconColor),
        horizontalSpace(4),
        Text(
          text,
          style: TextStyles.font12InterWhiteW400.copyWith(fontSize: 8.sp),
        ),
      ],
    );
  }
}

class _TopBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;

  const _TopBadge({required this.label, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 11.r,
            color: AppColors.orangeColorE9,
          ),
          horizontalSpace(4),
          Text(
            label,
            style: TextStyles.font10InterW400.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeCtaButton extends StatelessWidget {
  final bool compact;

  const _RecipeCtaButton({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: compact ? 8.h : 10.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: Text(
        'View Recipe',
        style: TextStyles.font14W700.copyWith(
          color: AppColors.blackColor,
          fontSize: compact ? 13.sp : 14.sp,
        ),
      ),
    );
  }
}
