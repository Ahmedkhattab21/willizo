import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/assets_manager.dart';

class ShopHeaderWidget extends StatelessWidget {
  const ShopHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          ImageAsset.appLogoIconTwo,
          height: 22.h,
          width: 146.w,
        ),
    
        Spacer(),
        SvgPicture.asset(
          ImageAsset.shopCircleIcon,
          height: 40.h,
          width: 40.w,
        ),
      ],
    );
  }
}
