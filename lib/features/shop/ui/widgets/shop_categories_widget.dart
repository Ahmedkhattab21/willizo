import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class ShopCategoriesWidget extends StatefulWidget {
  final ValueChanged<int> onCategorySelected; // 👈 callback to parent
  const ShopCategoriesWidget({super.key, required this.onCategorySelected});

  @override
  State<ShopCategoriesWidget> createState() => _ShopCategoriesWidgetState();
}

class _ShopCategoriesWidgetState extends State<ShopCategoriesWidget> {
  final List<String> categories = ["All", "Shoes", "Bags", "T-shirt"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Categories", style: TextStyles.font20WhiteColorW600),
            const Spacer(),
            Text("View all", style: TextStyles.font12GreenColorW500),
          ],
        ),
        verticalSpace(12),
        SizedBox(
          height: 36.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => horizontalSpace(8),
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => selectedIndex = index);
                  widget.onCategorySelected(index); // 👈 notify parent
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyles.font14primaryColorW400.copyWith(
                        color: isSelected
                            ? Colors.black
                            : AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
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
