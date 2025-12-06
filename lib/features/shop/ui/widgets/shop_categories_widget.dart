import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/shop/logic/cubit/categories_cubit.dart';

class ShopCategoriesWidget extends StatefulWidget {
  final ValueChanged<String?> onCategorySelected;
  const ShopCategoriesWidget({super.key, required this.onCategorySelected});

  @override
  State<ShopCategoriesWidget> createState() => _ShopCategoriesWidgetState();
}

class _ShopCategoriesWidgetState extends State<ShopCategoriesWidget> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoadingState) {
          return SizedBox(
            height: 60.h,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }

        if (state is CategoriesErrorState) {
          return SizedBox(
            height: 60.h,
            child: Center(
              child: Text(
                'Error loading categories',
                style: TextStyles.font14whiteColorColorW400,
              ),
            ),
          );
        }

        if (state is CategoriesLoadedState) {
          final categories = state.categoriesData.data;

          if (categories.isEmpty) {
            return const SizedBox.shrink();
          }

          if (selectedIndex == -1 && categories.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedIndex = 0;
              });
              widget.onCategorySelected(categories[0].slug);
              debugPrint(
                '🔵 [ShopCategoriesWidget] Auto-selected first category: ${categories[0].name} (slug: ${categories[0].slug})',
              );
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Categories", style: TextStyles.font20WhiteColorW600),
                  const Spacer(),
                  // Text("View all", style: TextStyles.font12GreenColorW500),
                ],
              ),
              verticalSpace(12),
              SizedBox(
                height: 36.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => horizontalSpace(8),
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        final selectedCategory = categories[index];
                        debugPrint(
                          '🔵 [ShopCategoriesWidget] Category selected: ${selectedCategory.name} (slug: ${selectedCategory.slug})',
                        );
                        setState(() => selectedIndex = index);
                        widget.onCategorySelected(selectedCategory.slug);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            categories[index].name,
                            style: TextStyles.font14primaryColorW400.copyWith(
                              color: isSelected
                                  ? Colors.black
                                  : AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
