import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/product_details/data/repo/product_details_repo.dart';
import 'package:willizo/features/product_details/logic/cubit/related_products_cubit.dart';
import 'package:willizo/features/shop/ui/widgets/shop_card_widget.dart';

class RelatedProductWidget extends StatelessWidget {
  final String productSlug;

  const RelatedProductWidget({super.key, required this.productSlug});

  @override
  Widget build(BuildContext context) {
    if (productSlug.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      create: (context) =>
          RelatedProductsCubit(getIt<ProductDetailsRepo>())
            ..getRelatedProducts(productSlug),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Related Products",
                style: TextStyles.font18InterW600.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
              const Spacer(),
              Text("View all", style: TextStyles.font12GreenColorW500),
            ],
          ),
          verticalSpace(10),
          BlocBuilder<RelatedProductsCubit, RelatedProductsState>(
            builder: (context, state) {
              if (state is RelatedProductsLoadingState) {
                return SizedBox(
                  height: 300.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }

              if (state is RelatedProductsErrorState) {
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
                                .read<RelatedProductsCubit>()
                                .getRelatedProducts(productSlug);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is RelatedProductsLoadedState) {
                final products = state.relatedProductsData.data;

                if (products.isEmpty) {
                  return SizedBox(
                    height: 200.h,
                    child: Center(
                      child: Text(
                        'No related products available',
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

                    // Get first image if available, otherwise use placeholder
                    final imageUrl = product.images.isNotEmpty
                        ? product.images[0].toString()
                        : "assets/images/banner_image.png";

                    return ShopProductCard(
                      image: imageUrl,
                      title: product.name,
                      year: year,
                      price: product.price,
                      rating: "4.8", // Default rating since not in API
                      product: product,
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
