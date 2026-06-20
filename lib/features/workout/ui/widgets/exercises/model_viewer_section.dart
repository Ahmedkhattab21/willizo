import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';
import 'package:willizo/features/workout/ui/widgets/exercises/body_360/body_360_viewer.dart';

class ModelViewerSection extends StatelessWidget {
  const ModelViewerSection({
    super.key,
    this.bodyPartGroups = const [],
  });

  final List<BodyPartModel> bodyPartGroups;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Body360Viewer(bodyPartGroups: bodyPartGroups),
    );
  }
}
