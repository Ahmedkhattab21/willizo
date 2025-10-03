import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/styles.dart';

class HomeTopHeaderWidget extends StatelessWidget {
  const HomeTopHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: const Padding(
            padding: EdgeInsets.all(2),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
            ),
          ),
        ),

        const SizedBox(width: 12),
        // Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good Morning', style: TextStyles.font12GreenColorW400),
              SizedBox(height: 4),
              Text('Mohamed Hisham', style: TextStyles.font16WhiteColorW400),
            ],
          ),
        ),
        // Spacer / optional action
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, color: Colors.white54),
        ),
      ],
    );
  }
}
