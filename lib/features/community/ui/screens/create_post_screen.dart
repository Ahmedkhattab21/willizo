import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  XFile? _pickedImage;
  String _visibility = 'public';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _pickedImage = image);
    }
  }

  void _submit() {
    if (_pickedImage == null) return;
    CommunityCubit.get(context).createPost(
      mediaPath: _pickedImage!.path,
      visibility: _visibility,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommunityCubit, CommunityState>(
      listenWhen: (_, state) =>
          state is PostCreatedState || state is PostCreationErrorState,
      listener: (context, state) {
        if (state is PostCreatedState) {
          AppConstant.toast("Post shared successfully!", AppColors.primaryColor);
          Navigator.of(context).pop();
        } else if (state is PostCreationErrorState) {
          AppConstant.toast(
            state.failure.message,
            AppColors.redColor,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is PostCreatingState;

        return Scaffold(
          backgroundColor: AppColors.blackColor171C,
          appBar: AppBar(
            backgroundColor: AppColors.blackColor171C,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: AppColors.whiteColor, size: 24.r),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "New Post",
              style: TextStyles.font18WhiteColor700,
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: GestureDetector(
                  onTap: isLoading || _pickedImage == null ? null : _submit,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: _pickedImage != null && !isLoading
                          ? const LinearGradient(
                              colors: [
                                AppColors.greenColorEF,
                                AppColors.greenColorFD,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: _pickedImage == null || isLoading
                          ? AppColors.greyColorColor79
                          : null,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.blackColor,
                            ),
                          )
                        : Text(
                            "Share",
                            style: TextStyles.font14InterW600.copyWith(
                              color: AppColors.blackColor,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image picker area
                GestureDetector(
                  onTap: isLoading ? null : _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 240.h,
                    decoration: BoxDecoration(
                      color: AppColors.blackColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: _pickedImage != null
                            ? AppColors.primaryColor
                            : AppColors.greyColorColor79.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: _pickedImage != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(_pickedImage!.path),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 8.h,
                                right: 8.w,
                                child: GestureDetector(
                                  onTap: isLoading ? null : _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.blackColor.withValues(
                                        alpha: 0.7,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColors.whiteColor,
                                      size: 16.r,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.greenColorEF,
                                      AppColors.greenColorFD,
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: AppColors.blackColor,
                                  size: 32.r,
                                ),
                              ),
                              verticalSpace(12),
                              Text(
                                "Tap to select a photo",
                                style: TextStyles.font14whiteColorColorW400
                                    .copyWith(
                                  color: AppColors.greyColorColor79,
                                ),
                              ),
                              verticalSpace(4),
                              Text(
                                "JPEG, PNG or JPG",
                                style: TextStyles.font12greyColorColor79W400
                                    .copyWith(fontSize: 11.sp),
                              ),
                            ],
                          ),
                  ),
                ),
                verticalSpace(24),
                // Visibility selector
                Text(
                  "Who can see this?",
                  style: TextStyles.font14whiteColorColorW400,
                ),
                verticalSpace(12),
                Row(
                  children: [
                    _VisibilityOption(
                      label: "Public",
                      icon: Icons.public,
                      selected: _visibility == 'public',
                      onTap: isLoading
                          ? null
                          : () => setState(() => _visibility = 'public'),
                    ),
                    horizontalSpace(12),
                    _VisibilityOption(
                      label: "Friends",
                      icon: Icons.people,
                      selected: _visibility == 'friends',
                      onTap: isLoading
                          ? null
                          : () => setState(() => _visibility = 'friends'),
                    ),
                    horizontalSpace(12),
                    _VisibilityOption(
                      label: "Private",
                      icon: Icons.lock_outline,
                      selected: _visibility == 'private',
                      onTap: isLoading
                          ? null
                          : () => setState(() => _visibility = 'private'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _VisibilityOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _VisibilityOption({
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [AppColors.greenColorEF, AppColors.greenColorFD],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: selected ? null : AppColors.blackColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : AppColors.greyColorColor79.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? AppColors.blackColor : AppColors.greyColorColor79,
                size: 20.r,
              ),
              verticalSpace(4),
              Text(
                label,
                style: TextStyles.font12greyColorColor79W400.copyWith(
                  color: selected ? AppColors.blackColor : AppColors.greyColorColor79,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
