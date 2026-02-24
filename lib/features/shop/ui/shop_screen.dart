import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/all_products/ui/all_products_screen.dart';
import 'package:willizo/features/shop/logic/cubit/categories_cubit.dart';
import 'package:willizo/features/shop/logic/cubit/shop_cubit.dart';
import 'package:willizo/features/shop/ui/widgets/all_categories_body_widget.dart';
import 'package:willizo/features/shop/ui/widgets/featured_products_widget.dart';
import 'package:willizo/features/shop/ui/widgets/shop_banner_widget.dart';
import 'package:willizo/features/shop/ui/widgets/shop_header_widget.dart';
import 'package:willizo/features/shop/ui/widgets/category_products_widget.dart';
import 'package:willizo/features/shop/ui/widgets/shop_categories_widget.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String? selectedCategorySlug;
  bool _hasAutoSelectedFirstCategory = false;

  void _autoSelectFirstCategory(BuildContext context) {
    if (_hasAutoSelectedFirstCategory) return;

    final categoriesState = context.read<CategoriesCubit>().state;
    if (categoriesState is CategoriesLoadedState) {
      final categories = categoriesState.categoriesData.data;
      if (categories.isNotEmpty && selectedCategorySlug == null) {
        _hasAutoSelectedFirstCategory = true;
        final firstCategorySlug = categories[0].slug;
        debugPrint(
          '🟢 [ShopScreen] Auto-selecting first category: ${categories[0].name} (slug: $firstCategorySlug)',
        );
        setState(() {
          selectedCategorySlug = firstCategorySlug;
        });
      }
    }
  }

  Widget _buildCategoryBody() {
    if (selectedCategorySlug == null || selectedCategorySlug!.isEmpty) {
      return const AllCategoriesBodyWidget();
    }
    debugPrint(
      '🟢 [ShopScreen] Building category body for slug: $selectedCategorySlug',
    );
    return CategoryProductsWidget(categorySlug: selectedCategorySlug!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShopHeaderWidget(),
              verticalSpace(16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.wait([
                      context.read<ShopCubit>().getFeaturedProducts(),
                      context.read<CategoriesCubit>().getCategories(),
                    ]);
                  },
                  color: AppColors.primaryColor,
                  backgroundColor: AppColors.greyColor2727,
                  strokeWidth: 2,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShopBannerWidget(),
                        verticalSpace(10),
                        Row(
                          children: [
                            Text(
                              "Featured Products",
                              style: TextStyles.font18InterW600.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllProductsScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "View all",
                                style: TextStyles.font12GreenColorW500,
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(10),
                        const FeaturedProductsWidget(),
                        verticalSpace(10),
                        BlocListener<CategoriesCubit, CategoriesState>(
                          listener: (context, state) {
                            if (state is CategoriesLoadedState) {
                              _autoSelectFirstCategory(context);
                            }
                          },
                          child: ShopCategoriesWidget(
                            onCategorySelected: (categorySlug) {
                              debugPrint(
                                '🟢 [ShopScreen] Category changed to slug: $categorySlug',
                              );
                              setState(() => selectedCategorySlug = categorySlug);
                            },
                          ),
                        ),
                        verticalSpace(16),
                        _buildCategoryBody(),
                        verticalSpace(16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
