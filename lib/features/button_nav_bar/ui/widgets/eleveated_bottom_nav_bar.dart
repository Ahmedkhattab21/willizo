import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/features/button_nav_bar/data/nav_itme.dart';
import 'package:willizo/features/button_nav_bar/logic/cubit/button_nav_bar_cubit.dart';
import 'package:willizo/features/button_nav_bar/logic/cubit/button_nav_bar_state.dart';

class ElevatedBottomNavBar extends StatelessWidget {
  const ElevatedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonNavBarCubit, NavigationState>(
      builder: (context, state) {
        return Container(
          height: 90.h,
          padding: EdgeInsets.only(bottom: 20.h),
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF141414), // Dark grey capsule
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(state.items.length, (index) {
                final isSelected = index == state.selectedIndex;
                final item = state.items[index];

                return GestureDetector(
                  onTap: () {
                    context.read<ButtonNavBarCubit>().selectItem(index);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 16.w : 10.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.5),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildNavIcon(
                              item,
                              isSelected: isSelected,
                              size: isSelected ? 24.sp : 22.sp,
                            ),
                            if (isSelected) ...[
                              horizontalSpace(6),
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isSelected) ...[
                        verticalSpace(2),
                        Container(
                          width: 4.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ] else
                        SizedBox(height: 6.h), // placeholder for dot + space
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavIcon(
    NavItem item, {
    required bool isSelected,
    required double size,
  }) {
    if (item.isSvg) {
      return SvgPicture.asset(
        isSelected ? item.activeAssetPath! : item.inactiveAssetPath!,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(
          isSelected ? AppColors.blackColor : AppColors.greyColorF9,
          BlendMode.srcIn,
        ),
      );
    } else {
      return Icon(
        item.icon,
        color: isSelected ? AppColors.blackColor : AppColors.greyColorF9,
        size: size,
      );
    }
  }
}
