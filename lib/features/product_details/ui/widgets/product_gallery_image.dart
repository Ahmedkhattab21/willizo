import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class ProductImageGallery extends StatelessWidget {
  final List<String> images;
  final int selectedImage;
  final ValueChanged<int> onImageSelected;

  const ProductImageGallery({
    super.key,
    required this.images,
    required this.selectedImage,
    required this.onImageSelected,
  });

  bool _isNetworkImage(String image) {
    return image.startsWith('http://') || image.startsWith('https://');
  }

  bool _isAssetImage(String image) {
    return image.startsWith('assets/');
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return SizedBox(
        height: 260.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.asset(
            "assets/images/banner_image.png",
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 260.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: _isNetworkImage(images[selectedImage])
                ? Image.network(
                    images[selectedImage],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/banner_image.png",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    images[selectedImage],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/banner_image.png",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 64.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onImageSelected(index),
                child: Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: selectedImage == index
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: _isNetworkImage(images[index])
                        ? Image.network(
                            images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/banner_image.png",
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/banner_image.png",
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
