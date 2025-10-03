import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
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
          height: 75.h,
          decoration: BoxDecoration(
            color: AppColors.blackColor171C,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(state.items.length, (index) {
                  final isMiddle = index == state.middleIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // FIX: Pass the actual index that was tapped
                        context.read<ButtonNavBarCubit>().selectItem(index);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!isMiddle) ...[
                              _buildNavIcon(
                                state.items[index],
                                color: Colors.grey,
                                size: 26,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 60) / 2,
                top: -20,
                child: GestureDetector(
                  onTap: () => context.read<ButtonNavBarCubit>().selectItem(
                    state.middleIndex,
                  ),
                  child: Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Container(
                          key: ValueKey(state.selectedIndex),
                          width: 60,
                          height: 60,
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: _buildNavIcon(
                            state.items[state.selectedIndex],
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      verticalSpace(4),
                      Text(
                        state.items[state.selectedIndex].label,
                        style: TextStyles.font12WhiteColorW500,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavIcon(
    NavItem item, {
    required Color color,
    required double size,
  }) {
    if (item.isSvg) {
      return SvgPicture.asset(
        item.assetPath!,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else {
      return Icon(item.icon, color: color, size: size);
    }
  }
}
