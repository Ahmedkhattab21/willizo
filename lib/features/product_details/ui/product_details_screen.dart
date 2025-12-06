import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
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
import 'package:willizo/features/shop/data/models/shop_model_response.dart';
import 'package:willizo/features/shop/ui/widgets/quantity_widget.dart';
import 'package:willizo/features/product_details/ui/widgets/footer_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedImage = 0;
  int selectedColor = 0;
  int selectedSize = 0;
  int quantity = 2;

  List<String> get images {
    if (widget.product == null) {
      return ["assets/images/banner_image.png"];
    }

    final productImages = widget.product!.images;
    if (productImages.isEmpty) {
      return ["assets/images/banner_image.png"];
    }

    return productImages
        .map((img) => img.toString())
        .where((img) => img.isNotEmpty)
        .toList();
  }

  final colorsList = [
    Colors.white,
    Colors.grey.shade300,
    Colors.red,
    Colors.blue,
  ];

  final sizes = ["S", "M", "L"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                inStock: widget.product?.stockStatus == "in_stock",
                rating: 4.8,
                reviewCount: 247,
              ),
              verticalSpace(14),
              _ProductInfo(product: widget.product),
              verticalSpace(16),
              ProductPriceSection(
                currentPrice: widget.product != null
                    ? double.tryParse(widget.product!.price) ?? 0.0
                    : 0.0,
                originalPrice: widget.product?.comparePrice != null
                    ? double.tryParse(widget.product!.comparePrice!) ?? 0.0
                    : null,
                discountPercentage:
                    widget.product?.comparePrice != null &&
                        widget.product!.comparePrice!.isNotEmpty
                    ? (((double.tryParse(widget.product!.comparePrice!) ??
                                      0.0) -
                                  (double.tryParse(widget.product!.price) ??
                                      0.0)) /
                              (double.tryParse(widget.product!.comparePrice!) ??
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
                      colors: colorsList,
                      selectedIndex: selectedColor,
                      onColorSelected: (index) =>
                          setState(() => selectedColor = index),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: SizeSelector(
                      sizes: sizes,
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
                style: TextStyles.font14W600.copyWith(color: Colors.white),
              ),
              verticalSpace(10),
              QuantityWidget(
                quantity: quantity,
                onAdd: () => setState(() => quantity++),
                onRemove: () =>
                    setState(() => quantity > 1 ? quantity-- : null),
              ),
              verticalSpace(20),
              ProductActionButtons(
                onAddToCart: () {},
                onWishlist: () {},
                onShare: () {},
                onBuyNow: () {},
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
                        style: TextStyles.font16WhiteColorW500.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "3-5 business days",
                        style: TextStyles.font16WhiteColorW500.copyWith(
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
                        style: TextStyles.font16WhiteColorW500.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "3-5 business days",
                        style: TextStyles.font16WhiteColorW500.copyWith(
                          color: AppColors.greyColorFB,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpace(60),
              Text(
                "Product Description",
                style: TextStyles.font24WhiteColorW700.copyWith(
                  fontSize: 22.sp,
                ),
              ),
              Text(
                widget.product?.description ?? "No description available",
                style: TextStyles.font12InterW400.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 12.sp,
                ),
              ),
              verticalSpace(10),
              Text(
                "Key Features",
                style: TextStyles.font14W600.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
              CheckListWidget(
                items: [
                  "Adjusts easily in 5 to 5 lb increments",
                  "Space-efficient design replaces 10 pairs of dumbbells",
                  "Durable design withstands fall for easy weight adjustments",
                  "Durable steel construction with premium finish",
                  "Ergonomic handle with non-slip grip",
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
                  Text("Lenght:", style: TextStyles.font12InterW400),
                  Spacer(),
                  Text("50 inches", style: TextStyles.font12InterW400),
                ],
              ),
              verticalSpace(10),
              Row(
                children: [
                  Text("Width:", style: TextStyles.font12InterW400),
                  Spacer(),
                  Text("30 inches", style: TextStyles.font12InterW400),
                ],
              ),
              verticalSpace(10),
              Row(
                children: [
                  Text("Height:", style: TextStyles.font12InterW400),
                  Spacer(),
                  Text("18-45 inches", style: TextStyles.font12InterW400),
                ],
              ),
              verticalSpace(10),
              Row(
                children: [
                  Text("Weight:", style: TextStyles.font12InterW400),
                  Spacer(),
                  Text("60 pounds", style: TextStyles.font12InterW400),
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
              Text("Diminsions", style: TextStyles.font12InterW400),
              verticalSpace(10),
              Text(
                "16.5 x 16.5 x 48.5 inche (per dumbbell)",
                style: TextStyles.font12InterW400.copyWith(
                  color: AppColors.greyColorColor79,
                ),
              ),
              verticalSpace(10),
              Text("increments", style: TextStyles.font12InterW400),
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
              CustomReviews(),
              ReviewCard(
                starCount: 5,
                date: "June 15, 2023",
                title: "Best investment for my home gym",
                reviewerName: "Michael Thompson",
                reviewText:
                    "I've been using the ProRower X9 for 3 months now and it's exceeded all my expectations. The cushioning system is amazing.",
                helpfulCount: 128,
              ),
              verticalSpace(30),
              RelatedProductWidget(productSlug: widget.product?.slug ?? ""),
              verticalSpace(30),
              FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product? product;

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
