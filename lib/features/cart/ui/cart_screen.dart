import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/cart/logic/cubit/cart_cubit.dart';
import 'package:willizo/features/cart/logic/cubit/cart_state.dart';
import 'package:willizo/features/cart/ui/widgets/cart_item_widget.dart';
import 'package:willizo/features/cart/ui/widgets/order_summary_widget.dart';
import 'package:willizo/features/cart/ui/widgets/trust_badges_widget.dart';
import 'package:willizo/features/product_details/ui/widgets/back_button_widget.dart';
import 'package:willizo/features/shop/logic/cubit/badge_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xff1a1a1a),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text("Clear Cart", style: TextStyles.font18WhiteColor700),
        content: Text(
          "Are you sure you want to remove all items from your cart? This action cannot be undone.",
          style: TextStyles.font14GreyColorW400.copyWith(
            color: AppColors.greyColorColor79,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              "Cancel",
              style: TextStyles.font14W600.copyWith(
                color: AppColors.greyColorColor79,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CartCubit>().clearCart();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Clear All",
              style: TextStyles.font14W600.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 16.h, left: 16.w),
                child: const BackButtonWidget(),
              ),
            ),
            Expanded(
              child: BlocConsumer<CartCubit, CartState>(
                listener: (context, state) {
                  if (state is CartLoaded) {
                    // Update badge count when cart changes
                    getIt<BadgeCubit>().updateCartCount(
                      state.cartData.data.totalItems,
                    );
                    // Fetch checkout calculation only if it doesn't exist yet
                    if (state.checkoutData == null) {
                      context.read<CartCubit>().calculateCheckout(
                        addressId: 1,
                        shippingMethod: "standard",
                      );
                    }
                  } else if (state is CartCleared) {
                    // Clear badge count
                    getIt<BadgeCubit>().updateCartCount(0);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.greenColor7C,
                      ),
                    );
                    // Refresh cart to show empty state
                    context.read<CartCubit>().getCart();
                  } else if (state is CartError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.redColor,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CartLoading || state is CartClearing) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  } else if (state is CartLoaded) {
                    final cartData = state.cartData.data;
                    final cartItems = cartData.items;

                    if (cartItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64.sp,
                              color: AppColors.greyColorColor79,
                            ),
                            verticalSpace(16),
                            Text(
                              "Your cart is empty",
                              style: TextStyles.font16WhiteColorW400,
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                verticalSpace(20),
                                // Cart Header
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Cart Items (${cartData.totalItems})",
                                      style: TextStyles.font18WhiteColor700
                                          .copyWith(fontSize: 18.sp),
                                    ),
                                    TextButton.icon(
                                      onPressed: () =>
                                          _showClearCartDialog(context),
                                      icon: SvgPicture.asset(
                                        ImageAsset.deleteIcon,
                                      ),
                                      label: Text(
                                        "Clear All",
                                        style: TextStyles.font14W600.copyWith(
                                          color: AppColors.redColor,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpace(20),
                                // Cart Items List
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cartItems.length,
                                  itemBuilder: (context, index) {
                                    final item = cartItems[index];
                                    final product = item.product;
                                    final cartCubit = context.read<CartCubit>();

                                    // Calculate discount percentage
                                    final price =
                                        double.tryParse(product.price) ?? 0;
                                    final comparePrice =
                                        double.tryParse(
                                          product.comparePrice ?? "0",
                                        ) ??
                                        0;
                                    final discount = comparePrice > 0
                                        ? ((comparePrice - price) /
                                                  comparePrice *
                                                  100)
                                              .round()
                                        : 0;

                                    // Get first image if available
                                    final imageUrl = product.images.isNotEmpty
                                        ? product.images[0].toString()
                                        : null;

                                    // Get effective quantity (local or server)
                                    final effectiveQuantity = state.getQuantity(
                                      item.id,
                                      item.quantity,
                                    );
                                    final isUpdating = state.isUpdating(
                                      item.id,
                                    );
                                    final isDeleting = state.isDeleting(
                                      item.id,
                                    );

                                    return CartItemWidget(
                                      imageUrl: imageUrl,
                                      title: product.name,
                                      subtitle: product.description,
                                      price: price,
                                      originalPrice: comparePrice > 0
                                          ? comparePrice
                                          : price,
                                      discount: discount,
                                      quantity: effectiveQuantity,
                                      isUpdating: isUpdating,
                                      isDeleting: isDeleting,
                                      onAdd: () => cartCubit.incrementQuantity(
                                        item.id,
                                        effectiveQuantity,
                                      ),
                                      onRemove: () =>
                                          cartCubit.decrementQuantity(
                                            item.id,
                                            effectiveQuantity,
                                          ),
                                      onDelete: () =>
                                          cartCubit.deleteCartItem(item.id),
                                    );
                                  },
                                ),
                                verticalSpace(20),
                                Divider(
                                  color: AppColors.greyColorFB.withOpacity(0.3),
                                ),
                                verticalSpace(20),
                                // Order Summary
                                OrderSummaryWidget(
                                  subtotal: cartData.subtotal,
                                  checkoutData: state.checkoutData,
                                  cartItems: cartItems,
                                ),
                                verticalSpace(20),
                                // Trust Badges
                                const TrustBadgesWidget(),
                                verticalSpace(40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is CartError) {
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
                                context.read<CartCubit>().getCart(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                            ),
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
    );
  }
}
