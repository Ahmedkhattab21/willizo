import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/shop/logic/cubit/badge_cubit.dart';
import 'package:willizo/features/shop/ui/widgets/shop_card_widget.dart';
import 'package:willizo/features/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:willizo/features/wishlist/logic/cubit/wishlist_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(16),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: SvgPicture.asset(
                        ImageAsset.arrowBackIcon,
                        colorFilter: const ColorFilter.mode(
                          AppColors.whiteColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Wishlist",
                        style: TextStyles.font24InterW700.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w), // To balance the back button
                ],
              ),
              verticalSpace(24),
              Expanded(
                child: BlocConsumer<WishlistCubit, WishlistState>(
                  listener: (context, state) {
                    if (state is WishlistLoaded) {
                      // Update badge count when wishlist changes
                      getIt<BadgeCubit>().updateWishlistCount(
                        state.wishlistData.data.length,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is WishlistLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    } else if (state is WishlistLoaded) {
                      final wishlistItems = state.wishlistData.data;

                      if (wishlistItems.isEmpty) {
                        return Center(
                          child: Text(
                            "Your wishlist is empty",
                            style: TextStyles.font16WhiteColorW400,
                          ),
                        );
                      }

                      return GridView.builder(
                        itemCount: wishlistItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          childAspectRatio: 0.67.h,
                        ),
                        itemBuilder: (context, index) {
                          final item = wishlistItems[index];
                          final product = item.product;
                          final isDeleting = state.isDeleting(product.id);

                          // Extract year from createdAt
                          final year = product.createdAt.isNotEmpty
                              ? product.createdAt.substring(0, 4)
                              : "2025";

                          // Get first image if available, otherwise use placeholder
                          final imageUrl = product.images.isNotEmpty
                              ? product.images[0].toString()
                              : "assets/images/banner_image.png";

                          return ShopProductCard(
                            image: imageUrl,
                            title: product.name,
                            year: year,
                            price: product.price,
                            rating: product.averageRating.toString(),
                            product: product,
                            isWishlist: true,
                            isDeleting: isDeleting,
                            onRemoveFromWishlist: () => context
                                .read<WishlistCubit>()
                                .removeFromWishlist(product.id),
                          );
                        },
                      );
                    } else if (state is WishlistError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: TextStyles.font14whiteColorColorW400,
                              textAlign: TextAlign.center,
                            ),
                            verticalSpace(16),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<WishlistCubit>().getWishlist(),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
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
    );
  }
}
