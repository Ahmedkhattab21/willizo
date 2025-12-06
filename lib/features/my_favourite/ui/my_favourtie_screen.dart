import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/my_favourite/ui/widgets/favourite_card_widget.dart';

class MyFavouriteScreen extends StatelessWidget {
  const MyFavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: SvgPicture.asset(ImageAsset.arrowBackIcon),
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
                  // Spacer to balance the back button
                  SizedBox(width: 40.w),
                ],
              ),
            ),
            // Scrollable GridView
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    // Sample data - you can replace with actual data
                    final products = [
                      {
                        'image': 'assets/images/banner_image.png',
                        'title': 'Power Whey Protein',
                        'price': '59.99',
                        'rating': '4.5',
                        'isOnSale': true,
                      },
                      {
                        'image': 'assets/images/banner_image.png',
                        'title': 'Premium Gym Bag',
                        'price': '45.00',
                        'rating': '4.8',
                        'isOnSale': false,
                      },
                      {
                        'image': 'assets/images/banner_image.png',
                        'title': 'Yoga Mat Pro',
                        'price': '29.99',
                        'rating': '4.7',
                        'isOnSale': true,
                      },
                      {
                        'image': 'assets/images/banner_image.png',
                        'title': 'Resistance Bands',
                        'price': '19.99',
                        'rating': '4.6',
                        'isOnSale': false,
                      },
                      {
                        'image': 'assets/images/banner_image.png',
                        'title': 'Dumbbells Set',
                        'price': '89.99',
                        'rating': '4.9',
                        'isOnSale': true,
                      },
                      {
                        'image': 'assets/images/banner_image.png',
                        'title': 'Water Bottle',
                        'price': '15.99',
                        'rating': '4.4',
                        'isOnSale': false,
                      },
                    ];

                    final product = products[index % products.length];

                    return FavouriteCardWidget(
                      image: product['image'] as String,
                      title: product['title'] as String,
                      price: product['price'] as String,
                      rating: product['rating'] as String,
                      isOnSale: product['isOnSale'] as bool,
                      onDelete: () {
                        // Handle delete action
                        print('Delete ${product['title']}');
                      },
                      onTap: () {
                        // Handle card tap
                        print('Tapped ${product['title']}');
                      },
                    );
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
