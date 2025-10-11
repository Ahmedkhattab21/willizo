import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/shop/ui/widgets/all_categories_body_widget.dart';
import 'package:willizo/features/shop/ui/widgets/search_and_filter_widget.dart';
import 'package:willizo/features/shop/ui/widgets/shop_banner_widget.dart';
import 'package:willizo/features/shop/ui/widgets/shop_header_widget.dart';
import 'package:willizo/features/shop/ui/widgets/shop_categories_widget.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int selectedCategoryIndex = 0;

  Widget _buildCategoryBody() {
    switch (selectedCategoryIndex) {
      case 0:
        return const AllCategoriesBodyWidget();
      case 1:
        return const Center(child: Text("Shoes Section"));
      case 2:
        return const Center(child: Text("Bags Section"));
      case 3:
        return const Center(child: Text("T-shirts Section"));
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              const ShopHeaderWidget(),
              verticalSpace(16),
              const SearchAndFilterWidget(),
              verticalSpace(24),
              const ShopBannerWidget(),
              verticalSpace(18),
              ShopCategoriesWidget(
                onCategorySelected: (index) {
                  setState(() => selectedCategoryIndex = index);
                },
              ),
              verticalSpace(16),
              Expanded(child: _buildCategoryBody()),
            ],
          ),
        ),
      ),
    );
  }
}
