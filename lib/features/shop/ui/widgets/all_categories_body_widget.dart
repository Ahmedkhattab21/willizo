import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/features/shop/ui/widgets/shop_card_widget.dart';

class AllCategoriesBodyWidget extends StatelessWidget {
  const AllCategoriesBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.67.h,
      ),
      itemBuilder: (context, index) {
        return ShopProductCard(
          image: "assets/images/banner_image.png",
          title: "Snickers Off-White",
          year: "2024",
          price: "38.00",
          rating: "4.8",
        );
      },
    );
  }
}
