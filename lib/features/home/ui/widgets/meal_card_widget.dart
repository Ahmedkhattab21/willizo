import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';
import 'package:willizo/features/home/data/models/my_meal_plans_response_model.dart';

class MealCard extends StatelessWidget {
  final String mealTypeLabel;
  final String recipeName;
  final String description;
  final String? totalTimeLabel;

  const MealCard._({
    required this.mealTypeLabel,
    required this.recipeName,
    required this.description,
    this.totalTimeLabel,
  });

  factory MealCard.fromMeal(ScheduledMealModel meal) {
    final recipe = meal.recipe;
    final typeRaw = meal.mealType;
    final mealTypeLabel = typeRaw.isNotEmpty
        ? typeRaw.replaceAll('_', ' ').toUpperCase()
        : 'MEAL';
    final tt = recipe.totalTime;
    final totalTimeLabel = tt != null && tt > 0 ? '$tt Min' : null;
    return MealCard._(
      mealTypeLabel: mealTypeLabel,
      recipeName: recipe.name.isNotEmpty ? recipe.name : 'Meal',
      description: recipe.description,
      totalTimeLabel: totalTimeLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAsset.backgroundCardImage),
          fit: BoxFit.fill,
        ),
        gradient: const LinearGradient(
          colors: [AppColors.kCardBlueStart, AppColors.kCardBlueEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.kCardBlueStart.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.whiteColorEb,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(ImageAsset.mealIcon),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealTypeLabel,
                      style: TextStyles.font16BlackColorW400.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      recipeName,
                      style: TextStyles.font12whiteColorColorW400,
                    ),
                  ],
                ),
              ),
              _CardMenuButton(
                iconColor: Colors.white54,
                items: const ['Quick Look', 'Mark As Complete', 'Change Meal'],
              ),
            ],
          ),
          verticalSpace(14),
          Text(
            description.isNotEmpty ? description : 'No description',
            style: TextStyles.font12whiteColorColorW400.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpace(16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ButtonWidget(
                isLoading: false,
                buttonText: 'Start',
                textStyle: TextStyles.font14PrimaryColorW600.copyWith(
                  color: AppColors.blueColor1ED,
                  fontWeight: FontWeight.w800,
                ),
                icon: Icons.arrow_forward,
                iconColor: AppColors.blueColor1ED,
                backGroundColor: AppColors.whiteColorEb,
                borderRadius: 40,
                buttonWidth: 94.w,
                buttonHeight: 41.h,
                horizontalPadding: 18.w,
                verticalPadding: 10.h,
                onPressed: () {},
              ),
              if (totalTimeLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white24, width: 2),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, size: 18.r, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        totalTimeLabel!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print, color: Colors.white),
                label: const Text(
                  'Print Recipe !',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardMenuButton extends StatelessWidget {
  final Color iconColor;
  final List<String> items;

  const _CardMenuButton({required this.iconColor, required this.items});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert, color: iconColor),
      color: Colors.black,
      elevation: 8,
      offset: Offset(-4.w, 28.h),
      constraints: BoxConstraints(minWidth: 150.w, maxWidth: 154.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      onSelected: (_) {},
      itemBuilder: (context) => List.generate(items.length, (index) {
        final item = items[index];
        return PopupMenuItem<String>(
          value: item,
          height: 36.h,
          padding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: 36.h,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: index == 0 ? const Color(0xFF545454) : Colors.black,
              borderRadius: BorderRadius.vertical(
                top: index == 0 ? Radius.circular(8.r) : Radius.zero,
                bottom: index == items.length - 1
                    ? Radius.circular(8.r)
                    : Radius.zero,
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}
