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
import 'package:willizo/features/product_details/data/models/add_product_to_cart_request_response.dart';
import 'package:willizo/features/shop/logic/cubit/badge_cubit.dart';
import 'package:willizo/features/product_details/data/models/product_details_response_model.dart';
import 'package:willizo/features/product_details/logic/cubit/product_details_cubit.dart';
import 'package:willizo/features/product_details/ui/widgets/back_button_widget.dart';
import 'package:willizo/features/product_details/ui/widgets/check_list_widget.dart';
import 'package:willizo/features/product_details/ui/widgets/color_selector_widget.dart';
import 'package:willizo/features/product_details/ui/widgets/custom_reviews.dart';
import 'package:willizo/features/product_details/ui/widgets/product_action_widget.dart';
import 'package:willizo/features/product_details/ui/widgets/product_gallery_image.dart';
import 'package:willizo/features/product_details/ui/widgets/product_price_section.dart';
import 'package:willizo/features/product_details/ui/widgets/product_rating_badge.dart';
import 'package:willizo/features/product_details/ui/widgets/related_product_widget.dart';
import 'package:willizo/features/product_details/ui/widgets/review_card_widget.dart';
import 'package:willizo/features/product_details/ui/widgets/size_selector.dart';
import 'package:willizo/features/shop/ui/widgets/quantity_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedImage = 0;
  int selectedColor = 0;
  int selectedSize = 0;
  int quantity = 1;
  bool isItemAdded = false;
  bool isItemInWishlist = false;
  bool _isBuyNowFlow = false;

  List<OptionValue> _optionValues(ProductData product, String optionName) {
    final normalizedName = optionName.toLowerCase();
    for (final option in product.options) {
      if (option.name.toLowerCase() == normalizedName) {
        return option.values;
      }
    }
    return [];
  }

  ProductVariant? _selectedVariant(ProductData product) {
    final selectedValues = <String>{};
    final colors = _optionValues(product, 'Color');
    final sizes = _optionValues(product, 'Size');

    if (colors.isNotEmpty && selectedColor < colors.length) {
      selectedValues.add(colors[selectedColor].id);
    }
    if (sizes.isNotEmpty && selectedSize < sizes.length) {
      selectedValues.add(sizes[selectedSize].id);
    }
    if (selectedValues.isEmpty) {
      return product.variants.isNotEmpty ? product.variants.first : null;
    }

    for (final variant in product.variants) {
      final variantValues = variant.optionValues.toSet();
      if (selectedValues.every(variantValues.contains)) {
        return variant;
      }
    }
    return product.variants.isNotEmpty ? product.variants.first : null;
  }

  int _availableStock(ProductData product) {
    return _selectedVariant(product)?.stockQuantity ?? product.stockQuantity;
  }

  void _clampQuantity(ProductData product) {
    final stock = _availableStock(product);
    if (stock > 0 && quantity > stock) {
      quantity = stock;
    }
  }

  Color _optionColor(OptionValue value) {
    final hex = value.hexColor;
    if (hex == null || hex.isEmpty) return Colors.grey;
    final normalizedHex = hex.startsWith('#') ? hex.substring(1) : hex;
    final colorValue = int.tryParse('ff$normalizedHex', radix: 16);
    return colorValue == null ? Colors.grey : Color(colorValue);
  }

  List<String> getProductImages(ProductData? product) {
    if (product == null) {
      return ["assets/images/banner_image.png"];
    }

    List<String> images = [];

    if (product.primaryImage != null && product.primaryImage!.isNotEmpty) {
      images.add(product.primaryImage!);
    }

    if (product.images.isNotEmpty) {
      images.addAll(
        product.images
            .map((img) => img.toString())
            .where((img) => img.isNotEmpty && img != product.primaryImage)
            .toList(),
      );
    }

    if (images.isEmpty) {
      return ["assets/images/banner_image.png"];
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("this is our product id ${widget.productId}");
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      body: SafeArea(
        child: BlocListener<ProductDetailsCubit, ProductDetailsState>(
          listener: (context, state) {
            if (state is AddToCartSuccessState) {
              final shouldOpenCart = _isBuyNowFlow;
              setState(() {
                isItemAdded = true;
                _isBuyNowFlow = false;
              });
              // Update cart badge count
              getIt<BadgeCubit>().incrementCartCount();
              if (shouldOpenCart) {
                context.pushNamed(Routes.cartScreen);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.response.message),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            } else if (state is AddProductToWishlistSuccessState) {
              setState(() {
                isItemInWishlist = true;
              });
              // Update wishlist badge count
              getIt<BadgeCubit>().incrementWishlistCount();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else if (state is RemoveFromWishlistSuccessState) {
              setState(() {
                isItemInWishlist = false;
              });
              // Update wishlist badge count
              getIt<BadgeCubit>().decrementWishlistCount();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Product removed from wishlist"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state is AddToCartErrorState) {
              setState(() {
                _isBuyNowFlow = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is AddProductToWishlistErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is RemoveFromWishlistErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CreateReviewSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review submitted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is ProductDetailsLoadedState) {
              setState(() {
                isItemInWishlist =
                    state.productDetails.data?.isInWishlist ?? false;
                isItemAdded = state.productDetails.data?.isInCart ?? false;
              });
            }
          },
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
                child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                  buildWhen: (previous, current) =>
                      current is ProductDetailsLoadingState ||
                      current is ProductDetailsErrorState ||
                      current is ProductDetailsLoadedState,
                  builder: (context, state) {
                    if (state is ProductDetailsLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    } else if (state is ProductDetailsErrorState) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (state is ProductDetailsLoadedState) {
                      final product = state.productDetails.data;
                      if (product == null) {
                        return const Center(
                          child: Text(
                            "Product not found",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      final images = getProductImages(product);
                      final colorValues = _optionValues(product, 'Color');
                      final sizeValues = _optionValues(product, 'Size');
                      final selectedVariant = _selectedVariant(product);

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductImageGallery(
                              images: images,
                              selectedImage: selectedImage,
                              onImageSelected: (index) =>
                                  setState(() => selectedImage = index),
                            ),
                            verticalSpace(16),
                            ProductRatingBadge(
                              inStock: product.stockStatus == "in_stock",
                              rating: product.averageRating.toDouble(),
                              reviewCount: product.reviewCount,
                            ),
                            verticalSpace(14),
                            _ProductInfo(product: product),
                            verticalSpace(16),
                            ProductPriceSection(
                              currentPrice:
                                  double.tryParse(product.price) ?? 0.0,
                              originalPrice: product.comparePrice != null
                                  ? double.tryParse(product.comparePrice!) ??
                                        0.0
                                  : null,
                              discountPercentage:
                                  product.comparePrice != null &&
                                      product.comparePrice!.isNotEmpty
                                  ? (((double.tryParse(product.comparePrice!) ??
                                                    0.0) -
                                                (double.tryParse(
                                                      product.price,
                                                    ) ??
                                                    0.0)) /
                                            (double.tryParse(
                                                  product.comparePrice!,
                                                ) ??
                                                1.0) *
                                            100)
                                        .round()
                                        .toInt()
                                  : null,
                            ),
                            verticalSpace(20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ColorSelector(
                                    colors: colorValues
                                        .map(_optionColor)
                                        .toList(),
                                    selectedIndex: selectedColor,
                                    onColorSelected: (index) => setState(() {
                                      selectedColor = index;
                                      _clampQuantity(product);
                                    }),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: SizeSelector(
                                    sizes: sizeValues
                                        .map((value) => value.value)
                                        .toList(),
                                    selectedIndex: selectedSize,
                                    onSizeSelected: (index) => setState(() {
                                      selectedSize = index;
                                      _clampQuantity(product);
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            verticalSpace(24),
                            Text(
                              "Quantity",
                              style: TextStyles.font14W600.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            verticalSpace(10),
                            QuantityWidget(
                              quantity: quantity,
                              canAdd: quantity < _availableStock(product),
                              canRemove: quantity > 1,
                              onAdd: () => setState(() {
                                final stock = _availableStock(product);
                                if (quantity < stock) {
                                  quantity++;
                                }
                              }),
                              onRemove: () => setState(
                                () => quantity > 1 ? quantity-- : null,
                              ),
                            ),
                            verticalSpace(20),
                            BlocBuilder<
                              ProductDetailsCubit,
                              ProductDetailsState
                            >(
                              builder: (context, state) {
                                final isCartLoading =
                                    state is AddToCartLoadingState;
                                return ProductActionButtons(
                                  isAddToCartLoading:
                                      isCartLoading && !_isBuyNowFlow,
                                  isBuyNowLoading:
                                      isCartLoading && _isBuyNowFlow,
                                  isWishlistLoading:
                                      state
                                          is AddProductToWishlistLoadingState ||
                                      state is RemoveFromWishlistLoadingState,
                                  isAdded: isItemAdded,
                                  isInWishlist: isItemInWishlist,
                                  onAddToCart: () {
                                    if (isCartLoading) return;
                                    setState(() {
                                      _isBuyNowFlow = false;
                                    });
                                    context
                                        .read<ProductDetailsCubit>()
                                        .addProductToCart(
                                          AddProductToCartRequest(
                                            productId: product.id,
                                            quantity: quantity,
                                            variantId: selectedVariant?.id,
                                          ),
                                        );
                                  },
                                  onWishlist: () {
                                    if (isItemInWishlist) {
                                      context
                                          .read<ProductDetailsCubit>()
                                          .removeFromWishlist(product.id);
                                    } else {
                                      context
                                          .read<ProductDetailsCubit>()
                                          .addProductToWishlist(product.id);
                                    }
                                  },
                                  onShare: () {},
                                  onBuyNow: () {
                                    if (isCartLoading) return;
                                    if (isItemAdded) {
                                      context.pushNamed(Routes.cartScreen);
                                      return;
                                    }
                                    setState(() {
                                      _isBuyNowFlow = true;
                                    });
                                    context
                                        .read<ProductDetailsCubit>()
                                        .addProductToCart(
                                          AddProductToCartRequest(
                                            productId: product.id,
                                            quantity: quantity,
                                            variantId: selectedVariant?.id,
                                          ),
                                        );
                                  },
                                );
                              },
                            ),
                            verticalSpace(20),
                            Divider(color: AppColors.greyColorFB),
                            verticalSpace(20),
                            _FulfillmentInfo(product: product),
                            verticalSpace(20),
                            _ProductSection(
                              title: 'Product Description',
                              child: Text(
                                product.description,
                                style: TextStyles.font12InterW400.copyWith(
                                  color: AppColors.greyColorColor79,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            if (product.keyFeatures.isNotEmpty) ...[
                              verticalSpace(18),
                              _ProductSection(
                                title: 'Key Features',
                                child: CheckListWidget(
                                  items: product.keyFeatures,
                                ),
                              ),
                            ],
                            if (product.dimensions != null &&
                                product.dimensions!
                                    .toDisplayMap()
                                    .isNotEmpty) ...[
                              verticalSpace(18),
                              _ProductSection(
                                title: 'Dimensions',
                                child: _KeyValueRows(
                                  items: product.dimensions!.toDisplayMap(),
                                ),
                              ),
                            ],
                            verticalSpace(18),
                            _ProductSection(
                              title: 'Specifications',
                              child: _KeyValueRows(
                                items: {
                                  if (product.specifications.isNotEmpty)
                                    ...product.specifications,
                                  if (product.material.isNotEmpty)
                                    'Material': product.material,
                                  if (product.warranty != null &&
                                      product.warranty!.isNotEmpty)
                                    'Warranty': product.warranty!,
                                  if (product.sku.isNotEmpty)
                                    'SKU': product.sku,
                                  if (product.category.name.isNotEmpty)
                                    'Category': product.category.name,
                                  'Stock': product.stockQuantity.toString(),
                                },
                              ),
                            ),
                            verticalSpace(50),
                            Builder(
                              builder: (context) {
                                final cubit = context
                                    .read<ProductDetailsCubit>();
                                final summary = cubit.ratingSummary;
                                return CustomReviews(
                                  productId: product.id,
                                  rating:
                                      summary?.averageStars ??
                                      product.averageRating.toDouble(),
                                  reviewCount:
                                      summary?.totalReviews ??
                                      product.reviewCount,
                                  ratingDistribution:
                                      summary?.ratingDistribution ?? const {},
                                );
                              },
                            ),
                            Column(
                              children: context
                                  .read<ProductDetailsCubit>()
                                  .reviewsList
                                  .map((review) {
                                    return ReviewCard(
                                      starCount: review.rating,
                                      date: review.createdAt.split('T')[0],
                                      title: review.title,
                                      reviewerName: review.user.name,
                                      reviewText: review.comment,
                                      helpfulCount: 0,
                                    );
                                  })
                                  .toList(),
                            ),
                            verticalSpace(20),
                            Center(
                              child: Container(
                                width: 170.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Load More Reviews",
                                    style: TextStyles.font12PrimaryColorW700
                                        .copyWith(
                                          fontFamily: "Inter",
                                          fontSize: 10.sp,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            verticalSpace(30),
                            RelatedProductWidget(productSlug: product.slug),
                            verticalSpace(30),
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

class _FulfillmentInfo extends StatelessWidget {
  const _FulfillmentInfo({required this.product});

  final ProductData product;

  @override
  Widget build(BuildContext context) {
    final deliveryTitle = product.deliveryInfo?.freeDelivery == true
        ? 'Free Delivery'
        : 'Delivery';
    final deliveryTime = product.deliveryInfo?.deliveryTime.isNotEmpty == true
        ? product.deliveryInfo!.deliveryTime
        : 'Not specified';
    final returnTitle = product.returnInfo?.returnable == true
        ? 'Returns'
        : 'No Returns';
    final returnTime = product.returnInfo?.returnTime.isNotEmpty == true
        ? product.returnInfo!.returnTime
        : 'Not specified';

    return Row(
      children: [
        Expanded(
          child: _FulfillmentItem(
            icon: ImageAsset.shippingCar,
            title: deliveryTitle,
            subtitle: deliveryTime,
          ),
        ),
        horizontalSpace(14),
        Expanded(
          child: _FulfillmentItem(
            icon: ImageAsset.returnIcon,
            title: returnTitle,
            subtitle: returnTime,
          ),
        ),
      ],
    );
  }
}

class _FulfillmentItem extends StatelessWidget {
  const _FulfillmentItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 22.r, height: 22.r),
        horizontalSpace(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font16WhiteColorW500.copyWith(
                  fontSize: 14.sp,
                ),
              ),
              verticalSpace(3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font16WhiteColorW500.copyWith(
                  color: AppColors.greyColorFB,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductSection extends StatelessWidget {
  const _ProductSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.font14InterW400.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          verticalSpace(12),
          child,
        ],
      ),
    );
  }
}

class _KeyValueRows extends StatelessWidget {
  const _KeyValueRows({required this.items});

  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    final entries = items.entries.where((entry) => entry.value.isNotEmpty);
    return Column(
      children: entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _formatLabel(entry.key),
                  style: TextStyles.font12InterW400.copyWith(
                    color: AppColors.greyColorColor79,
                  ),
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Text(
                  entry.value,
                  textAlign: TextAlign.end,
                  style: TextStyles.font12InterW400.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatLabel(String value) {
    return value
        .split('_')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}

class _ProductInfo extends StatelessWidget {
  final ProductData? product;

  const _ProductInfo({this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product?.name ?? "Product Name",
          style: TextStyles.font24WhiteColorW700,
        ),
        SizedBox(height: 10.h),
        Text(
          product?.description ?? "No description available",
          style: TextStyles.font14InterW400.copyWith(
            color: AppColors.greyColorF9,
            fontSize: 12.sp,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
