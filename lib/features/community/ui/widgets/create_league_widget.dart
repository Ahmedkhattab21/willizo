import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/core/widgets/app_text_field.dart';
import 'package:willizo/features/community/data/models/create_league_request_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/join_league_widget.dart';

class CreateLeagueWidget extends StatefulWidget {
  final VoidCallback? onCreateLeague;
  final VoidCallback? onSuccess;

  const CreateLeagueWidget({super.key, this.onCreateLeague, this.onSuccess});

  @override
  State<CreateLeagueWidget> createState() => _CreateLeagueWidgetState();
}

class _CreateLeagueWidgetState extends State<CreateLeagueWidget> {
  bool _showCreateForm = false;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxMembersController = TextEditingController();
  String _privacy = 'private';
  String _type = 'general';
  bool _hasName = false;

  OutlineInputBorder get _border => OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
    borderRadius: BorderRadius.circular(10.r),
  );

  OutlineInputBorder get _errorBorder => OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.redColor, width: 2),
    borderRadius: BorderRadius.circular(10.r),
  );

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      final hasText = _nameController.text.isNotEmpty;
      if (hasText != _hasName) setState(() => _hasName = hasText);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showCreateForm) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create an Invitational League",
            style: TextStyles.font18WhiteColor700.copyWith(fontSize: 20.sp),
          ),
          verticalSpace(14),
          // League Name Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "League Name",
                style: TextStyles.font14WhiteColorW500.copyWith(
                  fontSize: 10.sp,
                ),
              ),
              verticalSpace(8),
              AppTextFormField(
                hintText: "Enter League Name",
                hintStyle: TextStyles.font14greyColorColorW400,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 20.w,
                ),
                textStyle: TextStyles.font14whiteColorColorW400,
                controller: _nameController,
                backgroundColor: AppColors.blackColor,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: SvgPicture.asset(ImageAsset.nameIcon),
                ),
                enabledBorder: _border,
                focusedBorder: _border,
                errorBorder: _errorBorder,
                focusedErrorBorder: _errorBorder,
                validator: (value) => null,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          verticalSpace(16),
          // Description Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description",
                style: TextStyles.font14WhiteColorW500.copyWith(
                  fontSize: 10.sp,
                ),
              ),
              verticalSpace(8),
              AppTextFormField(
                hintText: "Enter Description",
                hintStyle: TextStyles.font14greyColorColorW400,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 20.w,
                ),
                textStyle: TextStyles.font14whiteColorColorW400,
                controller: _descriptionController,
                backgroundColor: AppColors.blackColor,
                maxLines: 1,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: SvgPicture.asset(ImageAsset.nameIcon),
                ),
                enabledBorder: _border,
                focusedBorder: _border,
                errorBorder: _errorBorder,
                focusedErrorBorder: _errorBorder,
                validator: (value) => null,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          verticalSpace(16),
          Text(
            "Privacy",
            style: TextStyles.font14WhiteColorW500.copyWith(fontSize: 10.sp),
          ),
          verticalSpace(8),
          Row(
            children: [
              _PrivacyOption(
                label: "Private",
                selected: _privacy == 'private',
                onTap: () => setState(() => _privacy = 'private'),
              ),
              horizontalSpace(12),
              _PrivacyOption(
                label: "Public",
                selected: _privacy == 'public',
                onTap: () => setState(() => _privacy = 'public'),
              ),
            ],
          ),
          verticalSpace(16),
          Text(
            "Type",
            style: TextStyles.font14WhiteColorW500.copyWith(fontSize: 10.sp),
          ),
          verticalSpace(8),
          Row(
            children: [
              _PrivacyOption(
                label: "General",
                selected: _type == 'general',
                onTap: () => setState(() => _type = 'general'),
              ),
              horizontalSpace(12),
              _PrivacyOption(
                label: "Invitational",
                selected: _type == 'invitational',
                onTap: () => setState(() => _type = 'invitational'),
              ),
            ],
          ),
          verticalSpace(16),
          // Max Members Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Max Members",
                style: TextStyles.font14WhiteColorW500.copyWith(
                  fontSize: 10.sp,
                ),
              ),
              verticalSpace(8),
              AppTextFormField(
                hintText: "Enter Max Members",
                hintStyle: TextStyles.font14greyColorColorW400,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 20.w,
                ),
                textStyle: TextStyles.font14whiteColorColorW400,
                controller: _maxMembersController,
                backgroundColor: AppColors.blackColor,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: SvgPicture.asset(ImageAsset.groupIcon),
                ),
                enabledBorder: _border,
                focusedBorder: _border,
                errorBorder: _errorBorder,
                focusedErrorBorder: _errorBorder,
                validator: (value) => null,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          verticalSpace(12),
          Text(
            "Please think carefully before entering your league name. Please refer to the Terms & Conditions of entry for more information.",
            style: TextStyles.font12greyColorColor79W400.copyWith(
              color: AppColors.greyColorColor80,
              fontSize: 10.sp,
            ),
          ),
          verticalSpace(24),
          BlocConsumer<CommunityCubit, CommunityState>(
            listener: (context, state) {
              if (state is LeagueCreatedState) {
                AppConstant.toast(
                  "League created successfully",
                  AppColors.primaryColor,
                );
                CommunityCubit.get(context).getLeagues();
                widget.onSuccess?.call();
              } else if (state is LeagueCreationErrorState) {
                AppConstant.toast(
                  state.failure.message,
                  AppColors.redColor,
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is LeagueCreatingState;
              return GradientJoinButtonWidget(
                isEnabled: _hasName && !isLoading,
                onTap: _hasName && !isLoading
                    ? () => CommunityCubit.get(context).createLeague(
                          CreateLeagueRequestModel(
                            name: _nameController.text,
                            description: _descriptionController.text,
                            type: _type,
                            privacy: _privacy,
                            maxMembers: _maxMembersController.text.isNotEmpty
                                ? int.tryParse(_maxMembersController.text)
                                : null,
                          ),
                        )
                    : null,
                label: isLoading ? "Creating..." : "Create a league",
                icon: isLoading ? null : Icons.add,
              );
            },
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create an Invitational League",
          style: TextStyles.font18WhiteColor700.copyWith(fontSize: 20.sp),
        ),
        verticalSpace(8),
        Text(
          "Create your own league and add your friends.",
          style: TextStyles.font12greyColorColor79W400.copyWith(
            color: AppColors.greyColorColor80,
          ),
        ),
        verticalSpace(24),
        Text(
          "Classic Leagues",
          style: TextStyles.font16WhiteColorW600.copyWith(fontSize: 18.sp),
        ),
        verticalSpace(8),
        Text(
          "In a league with classic scoring, teams are ranked based on their total points in the game. You can join or leave a league with classic scoring at any point during the season.",
          style: TextStyles.font12greyColorColor79W400.copyWith(
            color: AppColors.whiteColorEb,
          ),
        ),
        verticalSpace(24),
        GradientJoinButtonWidget(
          onTap: () => setState(() => _showCreateForm = true),
          label: "Create a league",
          icon: Icons.add,
        ),
      ],
    );
  }
}

class _PrivacyOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PrivacyOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryColor : AppColors.blackColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected
                  ? AppColors.primaryColor
                  : AppColors.greyColorColor79,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyles.font14whiteColorColorW400.copyWith(
              color: selected
                  ? AppColors.blackColor
                  : AppColors.greyColorColor80,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
