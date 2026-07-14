import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/shop/data/repo/shop_repo.dart';
import 'package:willizo/features/shop/logic/cubit/category_products_cubit.dart';
import 'package:willizo/features/shop/ui/widgets/shop_card_widget.dart';

class CategoryProductsWidget extends StatelessWidget {
  final String categorySlug;

  const CategoryProductsWidget({super.key, required this.categorySlug});

  @override
  Widget build(BuildContext context) {
    if (categorySlug.isEmpty) {
      return const SizedBox.shrink();
    }

    debugPrint(
      '🟣 [CategoryProductsWidget] Building widget for category slug: $categorySlug',
    );

    return BlocProvider(
      key: ValueKey('category_products_$categorySlug'),
      create: (context) {
        debugPrint(
          '🟣 [CategoryProductsWidget] Creating new BlocProvider for slug: $categorySlug',
        );
        return CategoryProductsCubit(getIt<ShopRepo>())
          ..getCategoryProducts(categorySlug);
      },
      child: BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
        builder: (context, state) {
          if (state is CategoryProductsLoadingState) {
            return SizedBox(
              height: 300.h,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }

          if (state is CategoryProductsErrorState) {
            return SizedBox(
              height: 200.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: TextStyles.font14whiteColorColorW400,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<CategoryProductsCubit>()
                            .getCategoryProducts(categorySlug);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CategoryProductsLoadedState) {
            final products = state.categoryProductsData.data;

            debugPrint(
              '🟢 [CategoryProductsWidget] Displaying ${products.length} products for category slug: $categorySlug',
            );
            if (products.isNotEmpty) {
              debugPrint(
                '🟢 [CategoryProductsWidget] First product: ${products[0].name} (category: ${products[0].category.name}, slug: ${products[0].category.slug})',
              );
            }

            if (products.isEmpty) {
              return SizedBox(
                height: 200.h,
                child: Center(
                  child: Text(
                    'No products available in this category',
                    style: TextStyles.font14whiteColorColorW400,
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.67.h,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                // Extract year from createdAt
                final year = product.createdAt.isNotEmpty
                    ? product.createdAt.substring(0, 4)
                    : "2024";

                return ShopProductCard(
                  image: product.displayImage,
                  title: product.name,
                  year: year,
                  price: product.price,
                  rating: product.averageRating.toStringAsFixed(1),
                  product: product,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
