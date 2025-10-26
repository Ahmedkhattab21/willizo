import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChallengesBody extends StatelessWidget {
  const ChallengesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Challenges Screen",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
