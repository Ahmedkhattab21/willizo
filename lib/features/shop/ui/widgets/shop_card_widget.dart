import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/product_details/data/models/add_product_to_cart_request_response.dart';
import 'package:willizo/features/product_details/data/repo/product_details_repo.dart';
import 'package:willizo/features/shop/data/models/shop_model_response.dart';
import 'package:willizo/features/shop/logic/cubit/badge_cubit.dart';

class ShopProductCard extends StatefulWidget {
  final String image;
  final String title;
  final String year;
  final String price;
  final String rating;
  final Product? product;
  final bool isWishlist;
  final bool isDeleting;
  final VoidCallback? onRemoveFromWishlist;

  const ShopProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.year,
    required this.price,
    required this.rating,
    this.product,
    this.isWishlist = false,
    this.isDeleting = false,
    this.onRemoveFromWishlist,
  });

  @override
  State<ShopProductCard> createState() => _ShopProductCardState();
}

class _ShopProductCardState extends State<ShopProductCard> {
  bool _isInCart = false;
  bool _isInWishlist = false;
  bool _isCartLoading = false;
  bool _isWishlistLoading = false;

  @override
  void initState() {
    super.initState();
    _syncProductState();
  }

  @override
  void didUpdateWidget(covariant ShopProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product?.id != widget.product?.id ||
        oldWidget.product?.isInCart != widget.product?.isInCart ||
        oldWidget.product?.isInWishlist != widget.product?.isInWishlist) {
      _syncProductState();
    }
  }

  void _syncProductState() {
    _isInCart = widget.product?.isInCart ?? false;
    _isInWishlist = widget.product?.isInWishlist ?? widget.isWishlist;
  }

  Future<void> _addToCart() async {
    final product = widget.product;
    if (product == null || _isInCart || _isCartLoading) return;

    setState(() => _isCartLoading = true);
    final result = await getIt<ProductDetailsRepo>().addProductToCart(
      AddProductToCartRequest(productId: product.id, quantity: 1),
    );
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _isCartLoading = false);
        _showMessage(failure.message, isError: true);
      },
      (response) {
        setState(() {
          _isCartLoading = false;
          _isInCart = true;
        });
        getIt<BadgeCubit>().incrementCartCount();
        _showMessage(response.message);
      },
    );
  }

  Future<void> _toggleWishlist() async {
    final product = widget.product;
    if (product == null || _isWishlistLoading) return;

    setState(() => _isWishlistLoading = true);
    final repo = getIt<ProductDetailsRepo>();
    final wasInWishlist = _isInWishlist;
    final result = wasInWishlist
        ? await repo.removeFromWishlist(product.id)
        : await repo.addProductToWishlist(product.id);

    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _isWishlistLoading = false);
        _showMessage(failure.message, isError: true);
      },
      (_) {
        setState(() {
          _isWishlistLoading = false;
          _isInWishlist = !wasInWishlist;
        });
        if (wasInWishlist) {
          getIt<BadgeCubit>().decrementWishlistCount();
          _showMessage('Product removed from wishlist');
        } else {
          getIt<BadgeCubit>().incrementWishlistCount();
          _showMessage('Product added to wishlist');
        }
      },
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isDeleting ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {
            context.pushNamed(
              Routes.productDetailsScreen,
              arguments: {'productId': widget.product?.id},
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(7.r),
              border: Border.all(color: AppColors.primaryColor, width: 1.2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12.w,
                      right: 12.w,
                      top: 12.h,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.r),
                      child:
                          widget.image.startsWith('http://') ||
                              widget.image.startsWith('https://')
                          ? Image.network(
                              widget.image,
                              height: 101.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _placeholderImage();
                              },
                            )
                          : Image.asset(
                              widget.image,
                              height: 101.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _placeholderImage();
                              },
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: TextStyles.font10WhiteColorW600,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: _isCartLoading ? null : _addToCart,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isInCart
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              padding: EdgeInsets.all(3.w),
                              child: _isCartLoading
                                  ? SizedBox(
                                      width: 14.w,
                                      height: 14.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: _isInCart
                                            ? AppColors.blackColor
                                            : AppColors.primaryColor,
                                      ),
                                    )
                                  : Icon(
                                      _isInCart
                                          ? Icons.shopping_cart
                                          : Icons.add,
                                      size: 14,
                                      color: _isInCart
                                          ? AppColors.blackColor
                                          : AppColors.primaryColor,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(4),
                      Text(widget.year, style: TextStyles.font10WhiteColorW600),
                      verticalSpace(6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${widget.price}",
                            style: TextStyles.font12PrimaryColorW700,
                          ),
                          widget.isWishlist
                              ? GestureDetector(
                                  onTap: widget.isDeleting
                                      ? null
                                      : widget.onRemoveFromWishlist,
                                  child: widget.isDeleting
                                      ? SizedBox(
                                          width: 16.w,
                                          height: 16.h,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.primaryColor,
                                              ),
                                        )
                                      : SvgPicture.asset(
                                          ImageAsset.wishlistIcon,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.primaryColor,
                                            BlendMode.srcIn,
                                          ),
                                          height: 16.h,
                                          width: 16.w,
                                        ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: _isWishlistLoading
                                          ? null
                                          : _toggleWishlist,
                                      child: _isWishlistLoading
                                          ? SizedBox(
                                              width: 14.w,
                                              height: 14.w,
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                            )
                                          : SvgPicture.asset(
                                              ImageAsset.wishlistIcon,
                                              colorFilter: ColorFilter.mode(
                                                _isInWishlist
                                                    ? AppColors.primaryColor
                                                    : AppColors.whiteColor,
                                                BlendMode.srcIn,
                                              ),
                                              height: 14.h,
                                              width: 14.w,
                                            ),
                                    ),
                                    SizedBox(width: 6.w),
                                    SvgPicture.asset(ImageAsset.startIcon),
                                    SizedBox(width: 4.w),
                                    Text(
                                      widget.rating,
                                      style: TextStyles.font10WhiteColorW600,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Image.asset(
      "assets/images/banner_image.png",
      height: 101.h,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
