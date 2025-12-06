import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/shop/logic/cubit/shop_cubit.dart';
import 'package:willizo/features/shop/ui/widgets/shop_card_widget.dart';

class FeaturedProductsWidget extends StatelessWidget {
  const FeaturedProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopState>(
      builder: (context, state) {
        if (state is FetchShopLoadingState) {
          return SizedBox(
            height: 300.h,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }

        if (state is FetchShopErrorState) {
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
                      context.read<ShopCubit>().getFeaturedProducts();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is FetchShopLoadedState) {
          final products = state.shopData.data;

          if (products.isEmpty) {
            return SizedBox(
              height: 200.h,
              child: Center(
                child: Text(
                  'No featured products available',
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
              // Extract year from createdAt (format: "2025-11-05T05:36:36.000000Z")
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
    );
  }
}
