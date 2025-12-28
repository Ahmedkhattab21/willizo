import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/extentions.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/shop/data/models/shop_model_response.dart';

class ShopProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String year;
  final String price;
  final String rating;
  final Product? product;

  const ShopProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.year,
    required this.price,
    required this.rating,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            Routes.productDetailsScreen,
            arguments: {'productId': product?.id},
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(7.r),
            border: Border.all(color: AppColors.primaryColor, width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.r),
                  child:
                      image.startsWith('http://') ||
                          image.startsWith('https://')
                      ? Image.network(
                          image,
                          height: 101.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/banner_image.png",
                              height: 101.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          image,
                          height: 101.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/banner_image.png",
                              height: 101.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 12.h,
                ), // Changed this
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyles.font10WhiteColorW600,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryColor),
                          ),
                          padding: EdgeInsets.all(3.w),
                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(4),
                    Text(year, style: TextStyles.font10WhiteColorW600),
                    verticalSpace(6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$$price",
                          style: TextStyles.font12PrimaryColorW700,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(ImageAsset.startIcon),
                            SizedBox(width: 4.w),
                            Text(
                              rating,
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
    );
  }
}
