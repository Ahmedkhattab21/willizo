import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/button_widget.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage( ImageAsset.backgroundCardImage),fit: BoxFit.fill),
        gradient: const LinearGradient(
          colors: [AppColors.kCardBlueStart, AppColors.kCardBlueEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.kCardBlueStart.withOpacity(0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child:   Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.whiteColorEb,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(ImageAsset.mealIcon),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DIET MEAL',
                      style: TextStyles.font16BlackColorW400.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Eat Breakfast Meal',
                      style: TextStyles.font12whiteColorColorW400,
                    ),
                  ],
                ),
              ),

              // menu
              Column(
                children: const [
                  Icon(Icons.more_vert, color: Colors.white54),
                ],
              ),
            ],
          ),
          verticalSpace(14),
          Text(
            'Breakfast is important because it gives the body the energy it needs to start the day.',
            style: TextStyles.font12whiteColorColorW400.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpace(16),

          Row(
            children: [
              ButtonWidget(
                isLoading: false,
                buttonText: "Start",
                textStyle: TextStyles.font14PrimaryColorW600.copyWith(
                  color: AppColors.blueColor1ED,
                  fontWeight: FontWeight.w800,
                ),
                icon: Icons.arrow_forward,
                iconColor: AppColors.blueColor1ED,
                backGroundColor: AppColors.whiteColorEb,
                borderRadius: 40,
                buttonWidth: 94.w,
                buttonHeight: 41.h,
                horizontalPadding: 18.w,
                verticalPadding: 10.h,
                onPressed: () {},
              ),

              const SizedBox(width: 12),

              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print, color: Colors.white),
                label: const Text(
                  'Print Recipe !',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
