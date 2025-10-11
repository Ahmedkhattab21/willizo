import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class ShopBannerWidget extends StatefulWidget {
  const ShopBannerWidget({super.key});

  @override
  State<ShopBannerWidget> createState() => _ShopBannerWidgetState();
}

class _ShopBannerWidgetState extends State<ShopBannerWidget> {
  final PageController _pageController = PageController();
  final List<String> _banners = [
    "assets/images/banner_image.png",
    "assets/images/banner_image.png",
    "assets/images/banner_image.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 131.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _banners[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
        ),
        SizedBox(height: 8.h),
        SmoothPageIndicator(
          controller: _pageController,
          count: 3,
          axisDirection: Axis.horizontal,
          effect: SlideEffect(
            spacing: 8.0,
            radius: 8,
            dotWidth: 8.0.w,
            dotHeight: 8.0.h,
            strokeWidth: 1.5,
            dotColor: AppColors.greyColorColor6E,
            activeDotColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
