import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';

class TopFriendsScreen extends StatelessWidget {
  const TopFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 2, color: Colors.transparent),
                gradient: LinearGradient(
                  colors: [AppColors.greenColorEF, AppColors.greenColorFD],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF181C00),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 24.h,
                                width: 24.w,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.blueColorFB,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  ImageAsset.groupIcon,
                                  height: 16.h,
                                  width: 16.w,
                                ),
                              ),
                              horizontalSpace(8),
                              Text(
                                "Top Friends",
                                style: TextStyles.font16White2ColorW600,
                              ),
                            ],
                          ),
                          Text(
                            "Total Points",
                            style: TextStyles.font12InterW400.copyWith(
                              color: AppColors.greyColorD1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white, thickness: 1),

                    ListView.builder(
                      itemCount: 8,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // Highlight the user at index 4 (5th item) as "You"
                        bool isCurrentUser = index == 4;

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 12.w,
                            ),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    "https://randomuser.me/api/portraits/men/${index + 40}.jpg",
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                horizontalSpace(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isCurrentUser
                                            ? "You"
                                            : "Friend ${index + 1}",
                                        style: TextStyle(
                                          color: isCurrentUser
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "${(index + 1) * 10} exercises complete",
                                        style: TextStyle(
                                          color: isCurrentUser
                                              ? AppColors.greyColorColor80
                                              : Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${8543 - (index * 200)}",
                                      style: TextStyle(
                                        color: isCurrentUser
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "points",
                                      style: TextStyle(
                                        color: isCurrentUser
                                            ? AppColors.greyColorColor80
                                            : Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    verticalSpace(10),
                  ],
                ),
              ),
            ),
            verticalSpace(50),
          ],
        ),
      ),
    );
  }
}
