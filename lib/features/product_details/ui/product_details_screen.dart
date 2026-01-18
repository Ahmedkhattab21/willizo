import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/product_details/data/models/add_product_to_cart_request_response.dart';
import 'package:willizo/features/shop/logic/cubit/badge_cubit.dart';
import 'package:willizo/features/product_details/data/models/product_details_response_model.dart';
import 'package:willizo/features/product_details/logic/cubit/product_details_cubit.dart';
import 'package:willizo/features/product_details/ui/widgets/back_button_widget.dart';
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
              setState(() {
                isItemAdded = true;
              });
              // Update cart badge count
              getIt<BadgeCubit>().incrementCartCount();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
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
            } else if (state is ProductDetailsLoadedState) {
              setState(() {
                isItemInWishlist =
                    state.productDetails.data?.isInWishlist ?? false;
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
                                    colors:
                                        product.options.any(
                                          (opt) => opt.name == "Color",
                                        )
                                        ? product.options
                                              .firstWhere(
                                                (opt) => opt.name == "Color",
                                              )
                                              .values
                                              .map(
                                                (v) => v.hexColor != null
                                                    ? Color(
                                                        int.parse(
                                                          v.hexColor!
                                                              .replaceFirst(
                                                                '#',
                                                                '0xff',
                                                              ),
                                                        ),
                                                      )
                                                    : Colors.grey,
                                              )
                                              .toList()
                                        : [],
                                    selectedIndex: selectedColor,
                                    onColorSelected: (index) =>
                                        setState(() => selectedColor = index),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: SizeSelector(
                                    sizes:
                                        product.options.any(
                                          (opt) => opt.name == "Size",
                                        )
                                        ? product.options
                                              .firstWhere(
                                                (opt) => opt.name == "Size",
                                              )
                                              .values
                                              .map((v) => v.value)
                                              .toList()
                                        : [],
                                    selectedIndex: selectedSize,
                                    onSizeSelected: (index) =>
                                        setState(() => selectedSize = index),
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
                              onAdd: () => setState(() => quantity++),
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
                                return ProductActionButtons(
                                  isAddToCartLoading:
                                      state is AddToCartLoadingState,
                                  isWishlistLoading:
                                      state
                                          is AddProductToWishlistLoadingState ||
                                      state is RemoveFromWishlistLoadingState,
                                  isAdded: isItemAdded,
                                  isInWishlist: isItemInWishlist,
                                  onAddToCart: () {
                                    context
                                        .read<ProductDetailsCubit>()
                                        .addProductToCart(
                                          AddProductToCartRequest(
                                            productId: product.id,
                                            quantity: quantity,
                                            variantId:
                                                product.variants.isNotEmpty
                                                ? product.variants[0].id
                                                : null,
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
                                  onBuyNow: () {},
                                );
                              },
                            ),
                            verticalSpace(20),
                            Divider(color: AppColors.greyColorFB),
                            verticalSpace(20),
                            Row(
                              children: [
                                SvgPicture.asset(ImageAsset.shippingCar),
                                horizontalSpace(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Free Delivery",
                                      style: TextStyles.font16WhiteColorW500
                                          .copyWith(fontSize: 14.sp),
                                    ),
                                    Text(
                                      "3-5 business days",
                                      style: TextStyles.font16WhiteColorW500
                                          .copyWith(
                                            color: AppColors.greyColorFB,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                SvgPicture.asset(ImageAsset.returnIcon),
                                horizontalSpace(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Returns",
                                      style: TextStyles.font16WhiteColorW500
                                          .copyWith(fontSize: 14.sp),
                                    ),
                                    Text(
                                      "3-5 business days",
                                      style: TextStyles.font16WhiteColorW500
                                          .copyWith(
                                            color: AppColors.greyColorFB,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            verticalSpace(20),
                            Text(
                              "Dimensions",
                              style: TextStyles.font14InterW400.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                            verticalSpace(20),
                            Row(
                              children: [
                                Text(
                                  "Lenght:",
                                  style: TextStyles.font12InterW400,
                                ),
                                Spacer(),
                                Text(
                                  "50 inches",
                                  style: TextStyles.font12InterW400,
                                ),
                              ],
                            ),
                            verticalSpace(10),
                            Row(
                              children: [
                                Text(
                                  "Width:",
                                  style: TextStyles.font12InterW400,
                                ),
                                Spacer(),
                                Text(
                                  "30 inches",
                                  style: TextStyles.font12InterW400,
                                ),
                              ],
                            ),
                            verticalSpace(10),
                            Row(
                              children: [
                                Text(
                                  "Height:",
                                  style: TextStyles.font12InterW400,
                                ),
                                Spacer(),
                                Text(
                                  "18-45 inches",
                                  style: TextStyles.font12InterW400,
                                ),
                              ],
                            ),
                            verticalSpace(10),
                            Row(
                              children: [
                                Text(
                                  "Weight:",
                                  style: TextStyles.font12InterW400,
                                ),
                                Spacer(),
                                Text(
                                  "${product.weight} kg",
                                  style: TextStyles.font12InterW400,
                                ),
                              ],
                            ),
                            verticalSpace(20),
                            Text(
                              "Secifications",
                              style: TextStyles.font14InterW400.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                            verticalSpace(10),
                            Text(
                              "Diminsions",
                              style: TextStyles.font12InterW400,
                            ),
                            verticalSpace(10),
                            Text(
                              "16.5 x 16.5 x 48.5 inche (per dumbbell)",
                              style: TextStyles.font12InterW400.copyWith(
                                color: AppColors.greyColorColor79,
                              ),
                            ),
                            verticalSpace(10),
                            Text(
                              "increments",
                              style: TextStyles.font12InterW400,
                            ),
                            verticalSpace(10),
                            Text(
                              "16.5 x 16.5 x 48.5 inche (per dumbbell)",
                              style: TextStyles.font12InterW400.copyWith(
                                color: AppColors.greyColorColor79,
                              ),
                            ),
                            verticalSpace(10),
                            Text("Matrial", style: TextStyles.font12InterW400),
                            verticalSpace(10),
                            Text(
                              "16.5 x 16.5 x 48.5 inche (per dumbbell)",
                              style: TextStyles.font12InterW400.copyWith(
                                color: AppColors.greyColorColor79,
                              ),
                            ),
                            verticalSpace(10),
                            Text("Warranty", style: TextStyles.font12InterW400),
                            verticalSpace(10),
                            Text(
                              "16.5 x 16.5 x 48.5 inche (per dumbbell)",
                              style: TextStyles.font12InterW400.copyWith(
                                color: AppColors.greyColorColor79,
                              ),
                            ),
                            verticalSpace(10),
                            Text("Includes", style: TextStyles.font12InterW400),
                            verticalSpace(10),
                            Text(
                              "16.5 x 16.5 x 48.5 inche (per dumbbell)",
                              style: TextStyles.font12InterW400.copyWith(
                                color: AppColors.greyColorColor79,
                              ),
                            ),
                            verticalSpace(50),
                            CustomReviews(
                              rating: product.averageRating.toDouble(),
                              reviewCount: product.reviewCount,
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
