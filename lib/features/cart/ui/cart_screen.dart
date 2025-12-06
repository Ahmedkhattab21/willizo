import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/cart/ui/widgets/cart_item_widget.dart';
import 'package:willizo/features/cart/ui/widgets/cart_stepper_widget.dart';
import 'package:willizo/features/cart/ui/widgets/order_summary_widget.dart';
import 'package:willizo/features/cart/ui/widgets/trust_badges_widget.dart';
import 'package:willizo/features/product_details/ui/widgets/footer_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _currentStep = 0;

  void _onStepChanged(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CartStepperWidget(onStepChanged: _onStepChanged),
                    // Show cart items only when on Cart tab (step 0)
                    if (_currentStep == 0) ...[
                      verticalSpace(10),
                      // Cart Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cart Items (3)",
                            style: TextStyles.font18WhiteColor700.copyWith(
                              fontSize: 18.sp,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: SvgPicture.asset(ImageAsset.deleteIcon),
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
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(20),
                      // Cart Items List
                      CartItemWidget(
                        imageUrl:
                            "https://images.unsplash.com/photo-1605296867304-46d5465a13f1",
                        title: "Premium Gym Membership",
                        subtitle:
                            "Access to all gym facilities and group classes",
                        price: 49.99,
                        originalPrice: 59.99,
                        discount: 15,
                        quantity: 2,
                        onAdd: () {},
                        onRemove: () {},
                        onDelete: () {},
                      ),
                      CartItemWidget(
                        imageUrl:
                            "https://images.unsplash.com/photo-1579758629938-03607ccdbaba",
                        title: "Personal Training Session",
                        subtitle: "45-minute one-on-one training with coach",
                        price: 49.99,
                        originalPrice: 59.99,
                        discount: 15,
                        quantity: 2,
                        onAdd: () {},
                        onRemove: () {},
                        onDelete: () {},
                      ),
                      CartItemWidget(
                        imageUrl:
                            "https://images.unsplash.com/photo-1554284126-aa88f22d8b74",
                        title: "Protein Powder - 2lb",
                        subtitle: "Premium whey protein isolate, chocolate",
                        price: 49.99,
                        originalPrice: 59.99,
                        discount: 15,
                        quantity: 2,
                        onAdd: () {},
                        onRemove: () {},
                        onDelete: () {},
                      ),
                      verticalSpace(20),
                      Divider(color: AppColors.greyColorFB.withOpacity(0.3)),
                      verticalSpace(20),
                      // Order Summary
                      const OrderSummaryWidget(),
                      verticalSpace(20),
                      // Trust Badges
                      const TrustBadgesWidget(),
                      verticalSpace(40),
                    ],
                  ],
                ),
              ),
              // Footer (hidden on Confirmation tab)
              if (_currentStep != 3)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const FooterWidget(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
