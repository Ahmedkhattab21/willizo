import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/home/logic/cubit/home_cubit.dart';

class HomeTopHeaderWidget extends StatelessWidget {
  const HomeTopHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.select(
      (HomeCubit cubit) => cubit.state.accountData,
    );
    final name = profile?.name.isNotEmpty == true ? profile!.name : 'User';
    final imageUrl = profile?.profilePhoto ?? '';

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                child: imageUrl.isEmpty
                    ? Icon(Icons.person, color: Colors.white, size: 22.sp)
                    : null,
              ),
            ),
          ),
        ),
        horizontalSpace(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good Morning', style: TextStyles.font12GreenColorW400),
              const SizedBox(height: 4),
              Text(name, style: TextStyles.font16WhiteColorW400),
            ],
          ),
        ),
      ],
    );
  }
}
