import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/workout/ui/widgets/recipe_card_widget.dart';
import 'package:willizo/features/workout/ui/widgets/recipe_tab_item.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final List<String> _tabs = ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  
  int _selectedIndex = 0;

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.96,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return RecipeCard(
            name: 'Quinoa Salad',
            imageUrl:
                'https://img.freepik.com/free-photo/top-view-tasty-salad-with-vegetables_23-2148515491.jpg?semt=ais_hybrid&w=740&q=80',
            calories: '${(index + 1) * 100} cal',
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 31.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedIndex;
                  return RecipeTabItem(
                    label: _tabs[index],
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedIndex = index),
                  );
                },
              ),
            ),
            horizontalSpace(30),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
