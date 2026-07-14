import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/my_favourite/ui/widgets/favourite_card_widget.dart';
import 'package:willizo/features/shop/logic/cubit/badge_cubit.dart';
import 'package:willizo/features/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:willizo/features/wishlist/logic/cubit/wishlist_state.dart';

class MyFavouriteScreen extends StatelessWidget {
  const MyFavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: SvgPicture.asset(ImageAsset.arrowBackIcon),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "My Favourite",
                        style: TextStyles.font24InterW700.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: BlocConsumer<WishlistCubit, WishlistState>(
                  listener: (context, state) {
                    if (state is WishlistLoaded) {
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
                    }

                    if (state is WishlistError) {
                      return _FavouriteMessage(
                        message: state.message,
                        onRetry: () =>
                            context.read<WishlistCubit>().getWishlist(),
                      );
                    }

                    if (state is WishlistLoaded) {
                      final items = state.wishlistData.data;
                      if (items.isEmpty) {
                        return const _FavouriteMessage(
                          message: "Your favourite list is empty",
                        );
                      }

                      return GridView.builder(
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final product = item.product;
                          final isDeleting = state.isDeleting(product.id);

                          return FavouriteCardWidget(
                            image: product.displayImage,
                            title: product.name,
                            price: product.price,
                            rating: product.averageRating.toStringAsFixed(1),
                            isOnSale: product.comparePrice != null,
                            isDeleting: isDeleting,
                            onDelete: () => context
                                .read<WishlistCubit>()
                                .removeFromWishlist(product.id),
                            onTap: () => context.pushNamed(
                              Routes.productDetailsScreen,
                              arguments: {'productId': product.id},
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavouriteMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _FavouriteMessage({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.font16WhiteColorW400,
            ),
            if (onRetry != null) ...[
              verticalSpace(16),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.blackColor,
                ),
                child: const Text("Retry"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
