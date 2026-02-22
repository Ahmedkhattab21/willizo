import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/styles.dart';

class FriendsTabBarWidget extends StatefulWidget {
  final Function(int) onTabChanged;

  const FriendsTabBarWidget({super.key, required this.onTabChanged});

  @override
  State<FriendsTabBarWidget> createState() => _FriendsTabBarWidgetState();
}

class _FriendsTabBarWidgetState extends State<FriendsTabBarWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.blackColor17,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                widget.onTabChanged(0);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedIndex == 0
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    "All Friends",
                    style: TextStyles.font16WhiteColorW500.copyWith(
                      color: _selectedIndex == 0
                          ? AppColors.blackColor
                          : AppColors.greyColor62,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                widget.onTabChanged(1);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedIndex == 1
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    "Suggested",
                    style: TextStyles.font16WhiteColorW500.copyWith(
                      color: _selectedIndex == 1
                          ? AppColors.blackColor
                          : AppColors.greyColor62,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
