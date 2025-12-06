import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/styles.dart';

class FavouriteCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String rating;
  final bool isOnSale;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const FavouriteCardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
    this.isOnSale = false,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.blackColor,
          borderRadius: BorderRadius.circular(4.r), // Changed to 4.r
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Sale Badge
                  if (isOnSale)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Text(
                          "SALE",
                          style: TextStyles.font14W700.copyWith(
                            color: AppColors.blackColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content Section
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and Rating Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyles.font18WhiteColor700.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.orangeColorEA,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              rating,
                              style: TextStyles.font14whiteColorColorW400
                                  .copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Price and Delete Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "\$$price",
                          style: TextStyles.font18WhiteColor700.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: onDelete,
                          child: SvgPicture.asset(
                            ImageAsset.deleteIcon,
                            width: 20.w,
                            height: 20.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
