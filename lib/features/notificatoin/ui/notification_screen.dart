import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/notificatoin/ui/widgets/notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: SvgPicture.asset(ImageAsset.arrowBackIcon),
                  ),

                  const Spacer(),

                  Text(
                    'NOTIFICATIONS',
                    style: TextStyles.font14BebasNeueW400.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),

                  const Spacer(),

                  SvgPicture.asset(ImageAsset.deleteIcon),
                ],
              ),
            ),

            verticalSpace(20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: 3,
                  padding: const EdgeInsets.only(bottom: 24),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: NotificationItem(
                        title: 'Notification title',
                        timeAgo: '10 mins ago',
                        body:
                            'Lorem Ipsum is simply dummy text of the printing and typesetting',
                        avatarUrl:
                            'https://i.pravatar.cc/150?img=${index + 10}',
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
