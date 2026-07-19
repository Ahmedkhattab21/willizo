import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/features/shop/data/models/banners_response_model.dart';
import 'package:willizo/features/shop/data/repo/shop_repo.dart';

class ShopBannerWidget extends StatefulWidget {
  const ShopBannerWidget({super.key});

  @override
  State<ShopBannerWidget> createState() => _ShopBannerWidgetState();
}

class _ShopBannerWidgetState extends State<ShopBannerWidget> {
  final PageController _pageController = PageController();
  late final Future<List<BannerModel>> _bannersFuture;

  @override
  void initState() {
    super.initState();
    _bannersFuture = _getBanners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BannerModel>>(
      future: _bannersFuture,
      builder: (context, snapshot) {
        final banners = snapshot.data ?? const <BannerModel>[];
        final imageUrls = banners.map((banner) => banner.imageUrl).toList();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _BannerShell(
            pageController: _pageController,
            imageUrls: const [],
          );
        }

        return _BannerShell(
          pageController: _pageController,
          imageUrls: imageUrls.isEmpty
              ? const ["assets/images/banner_image.png"]
              : imageUrls,
        );
      },
    );
  }

  Future<List<BannerModel>> _getBanners() async {
    final result = await getIt<ShopRepo>().getBanners();
    return result.fold((_) => const <BannerModel>[], (banners) => banners);
  }
}

class _BannerShell extends StatelessWidget {
  final PageController pageController;
  final List<String> imageUrls;

  const _BannerShell({required this.pageController, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    final itemCount = imageUrls.isEmpty ? 1 : imageUrls.length;

    return Column(
      children: [
        SizedBox(
          height: 131.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: PageView.builder(
              controller: pageController,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (imageUrls.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }
                return _BannerImage(imageUrl: imageUrls[index]);
              },
            ),
          ),
        ),
        SizedBox(height: 8.h),
        SmoothPageIndicator(
          controller: pageController,
          count: itemCount,
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

class _BannerImage extends StatelessWidget {
  final String imageUrl;

  const _BannerImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    }
    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return Image.asset(
      "assets/images/banner_image.png",
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }
}
