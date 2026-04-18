import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/screens/create_post_screen.dart';

class SharePhotoWidget extends StatelessWidget {
  const SharePhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColors.greyColorColor79,
          backgroundImage: null,
          child: Icon(Icons.person, color: AppColors.whiteColor, size: 20.r),
        ),
        horizontalSpace(12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              final cubit = CommunityCubit.get(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: const CreatePostScreen(),
                  ),
                ),
              );
            },
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.greenColorEF, AppColors.greenColorFD],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.blackColor, size: 20.r),
                  horizontalSpace(6),
                  Text(
                    "Share a photo",
                    style: TextStyles.font14InterW600.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
