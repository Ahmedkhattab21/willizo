import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/all_products/data/repo/all_products_repo.dart';
import 'package:willizo/features/all_products/logic/cubit/all_products_cubit.dart';
import 'package:willizo/features/shop/ui/widgets/shop_card_widget.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AllProductsCubit(getIt<AllProductsRepo>())..getAllProducts(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    horizontalSpace(16),
                    Text(
                      "All Products",
                      style: TextStyles.font18InterW600.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
                verticalSpace(24),
                Expanded(
                  child: BlocBuilder<AllProductsCubit, AllProductsState>(
                    builder: (context, state) {
                      if (state is AllProductsLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }

                      if (state is AllProductsErrorState) {
                        return Center(
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
                                      .read<AllProductsCubit>()
                                      .getAllProducts();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is AllProductsLoadedState) {
                        final products = state.allProductsData.data;

                        if (products.isEmpty) {
                          return Center(
                            child: Text(
                              'No products available',
                              style: TextStyles.font14whiteColorColorW400,
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: EdgeInsets.only(bottom: 16.h),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 0.67.h,
                              ),
                          itemCount: products.length,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
