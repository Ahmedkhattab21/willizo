import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/account/ui/widgets/infro_tile_widget.dart';
import 'package:willizo/features/account/ui/widgets/profile_header_widget.dart';
import 'package:willizo/features/account/ui/widgets/subscription_card_widget.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: SvgPicture.asset(ImageAsset.arrowBackIcon),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'ACCOUNT',
                        style: TextStyles.font14BebasNeueW400,
                      ),
                    ),
                  ),
                  horizontalSpace(40),
                ],
              ),
              verticalSpace(12),
              const ProfileHeader(),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Personal Info',
                          style: TextStyles.font14whiteColorColorW400.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SvgPicture.asset(
                          ImageAsset.editIcon,
                          width: 20.w,
                          height: 20.h,
                        ),
                      ],
                    ),
                    verticalSpace(8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: const [
                        InfoTile(label: 'Name', value: 'Olivia Bennett'),
                        InfoTile(label: 'Phone', value: '+1 (555) 987-6543'),
                        InfoTile(label: 'Email', value: 'olivia.bee@gmail.com'),
                        InfoTile(label: 'Gender', value: 'male'),
                        InfoTile(label: 'Height', value: '172 cm'),
                        InfoTile(label: 'Weight', value: '72.4 kg'),
                      ],
                    ),
                  ],
                ),
              ),

              verticalSpace(14),
              const SubscriptionCard(),
              verticalSpace(18),
              Text('Workouts', style: TextStyles.font16WhiteColorW500),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('12', style: TextStyles.fon32whiteColorW700),
                            const SizedBox(height: 4),
                            Text(
                              'Last 7 days • +10%',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // const SizedBox(height: 12),
                    // const SizedBox(height: 160, child: NeonChart()),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
