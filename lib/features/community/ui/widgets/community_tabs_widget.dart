import 'package:flutter/material.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class CommunityTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<String> tabs = const ["Leaderboards", "Leagues", "Friends", "Feeds"];

  const CommunityTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tabs[index],
                    style: TextStyles.font14InterW600.copyWith(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.greyColorFB,
                    ),
                  ),
                  verticalSpace(10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 3,
                    width: isSelected ? (tabs[index].length * 7.7) : 0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                AppColors.greenColorEF,
                                AppColors.greenColorFD,
                              ],
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
