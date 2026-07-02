import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/app_constant.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/account/data/repo/account_repo.dart';
import 'package:willizo/features/account/logic/cubit/account_cubit.dart';
import 'package:willizo/features/account/ui/widgets/account_shimmer_widget.dart';
import 'package:willizo/features/account/ui/widgets/infro_tile_widget.dart';
import 'package:willizo/features/account/ui/onboarding_details_screen.dart';
import 'package:willizo/features/account/ui/widgets/profile_header_widget.dart';
import 'package:willizo/features/account/ui/widgets/subscription_card_widget.dart';
import 'package:willizo/features/login_and_signup/data/models/get_onboarding_step_response.dart';
import 'package:willizo/features/login_and_signup/data/repo/login_and_signup_repo.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static bool _isPickingProfilePhoto = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountCubit(getIt<AccountRepo>())..getAccountData(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        body: SafeArea(
          child: BlocConsumer<AccountCubit, AccountState>(
            listener: (context, state) {
              if (state is AccountActionSuccessState) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.signInScreen,
                  (route) => false,
                );
              } else if (state is UpdateProfilePhotoSuccessState) {
                AppConstant.toast(
                  'Profile photo updated successfully',
                  AppColors.primaryColor,
                );
              } else if (state is UpdateProfilePhotoErrorState) {
                AppConstant.toast(state.message, AppColors.redColor);
              }
            },
            builder: (context, state) {
              if (state is FetchAccountLoadingState) {
                return const AccountShimmerWidget();
              }

              if (state is FetchAccountErrorState) {
                return _AccountError(message: state.message);
              }

              final accountResponse = switch (state) {
                FetchAccountLoadedState() => state.accountData,
                AccountActionLoadingState() => state.accountData,
                AccountActionErrorState() => state.accountData,
                UpdateProfileLoadingState() => state.accountData,
                UpdateProfileErrorState() => state.accountData,
                UpdateProfileSuccessState() => state.accountData,
                UpdateProfilePhotoLoadingState() => state.accountData,
                UpdateProfilePhotoErrorState() => state.accountData,
                UpdateProfilePhotoSuccessState() => state.accountData,
                _ => null,
              };
              final accountData = accountResponse?.data;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 116.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AccountAppBar(),
                    verticalSpace(34),
                    ProfileHeader(
                      name: accountData?.name ?? 'Loading...',
                      email: accountData?.email ?? 'Loading...',
                      imageUrl: accountData?.profilePhoto ?? '',
                      onCameraTap: () => _pickAndUploadProfilePhoto(context),
                    ),
                    verticalSpace(38),
                    _SectionHeader(
                      title: 'Personal Info',
                      showEdit: true,
                      onEdit: accountData == null
                          ? null
                          : () async {
                              final updated = await Navigator.pushNamed(
                                context,
                                Routes.personalInfoScreen,
                                arguments: accountData,
                              );
                              if (updated == true && context.mounted) {
                                context.read<AccountCubit>().getAccountData();
                              }
                            },
                    ),
                    verticalSpace(16),
                    _DarkCard(
                      child: Wrap(
                        spacing: 16.w,
                        runSpacing: 22.h,
                        children: [
                          InfoTile(
                            label: 'Name',
                            value: accountData?.name ?? 'N/A',
                          ),
                          InfoTile(
                            label: 'Email',
                            value: accountData?.email ?? 'N/A',
                          ),
                          InfoTile(
                            label: 'Phone',
                            value: accountData?.phoneNumber ?? 'N/A',
                          ),
                          InfoTile(
                            label: 'Date of Birth',
                            value: accountData?.formattedDateOfBirth ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(28),
                    _SectionHeader(
                      title: 'Details',
                      showEdit: true,
                      onEdit: () async {
                        await Navigator.pushNamed(
                          context,
                          Routes.onboardingDetailsScreen,
                        );
                        if (context.mounted) {
                          context.read<AccountCubit>().getAccountData();
                        }
                      },
                    ),
                    verticalSpace(16),
                    const _OnboardingSummaryCard(),
                    verticalSpace(28),
                    const _SectionHeader(title: 'Subscription', showEdit: true),
                    verticalSpace(16),
                    const SubscriptionCard(),
                    verticalSpace(28),
                    Text(
                      'Shopping',
                      style: TextStyles.font20WhiteColorW600.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    verticalSpace(16),
                    _DarkCard(
                      child: Column(
                        children: [
                          _ShoppingRow(
                            title: 'My Orders',
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.myOrderScreen,
                            ),
                          ),
                          verticalSpace(18),
                          _ShoppingRow(
                            title: 'My Favorites',
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.myFavouriteScreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(28),
                    const _AccountTabs(),
                    verticalSpace(18),
                    _DarkCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Workouts',
                                style: TextStyles.font14greyColorColor80W400,
                              ),
                              verticalSpace(8),
                              Text('12', style: TextStyles.fon32whiteColorW700),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Last 7 days',
                                style: TextStyles.font14greyColorColor80W400,
                              ),
                              verticalSpace(10),
                              Text(
                                '+10%',
                                style: TextStyles.font18WhiteColorW600.copyWith(
                                  color: AppColors.greenColorF3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(24),
                    _AccountActions(
                      onLogout: () => context.read<AccountCubit>().logout(
                        actionType: AccountActionType.logout,
                      ),
                      onRemoveAccount: () => context
                          .read<AccountCubit>()
                          .logout(actionType: AccountActionType.removeAccount),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadProfilePhoto(BuildContext context) async {
    if (_isPickingProfilePhoto) return;
    _isPickingProfilePhoto = true;

    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedImage == null || !context.mounted) return;

      final extension = pickedImage.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        AppConstant.toast(
          'Only jpg, jpeg, and png images are allowed',
          AppColors.redColor,
        );
        return;
      }

      final imageSize = await pickedImage.length();
      if (!context.mounted) return;
      if (imageSize > 5 * 1024 * 1024) {
        AppConstant.toast(
          'Image size must be 5 MB or less',
          AppColors.redColor,
        );
        return;
      }

      context.read<AccountCubit>().updateProfilePhoto(pickedImage.path);
    } on PlatformException catch (error) {
      if (error.code != 'already_active' && context.mounted) {
        AppConstant.toast('Failed to pick image', AppColors.redColor);
      }
    } finally {
      _isPickingProfilePhoto = false;
    }
  }
}

class _AccountError extends StatelessWidget {
  const _AccountError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $message',
              textAlign: TextAlign.center,
              style: TextStyles.font14whiteColorColorW400,
            ),
            verticalSpace(16),
            ElevatedButton(
              onPressed: () => context.read<AccountCubit>().getAccountData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Account',
        textAlign: TextAlign.center,
        style: TextStyles.font24WhiteColorW700,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.showEdit = false,
    this.onEdit,
  });

  final String title;
  final bool showEdit;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyles.font20WhiteColorW600.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (showEdit)
          GestureDetector(
            onTap: onEdit,
            child: SvgPicture.asset(
              ImageAsset.editIcon,
              width: 22.r,
              height: 22.r,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
      ],
    );
  }
}

class _DarkCard extends StatelessWidget {
  const _DarkCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.greyColor27,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _OnboardingSummaryCard extends StatelessWidget {
  const _OnboardingSummaryCard();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetOnboardingStepResponseModel?>(
      future: _loadStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _DarkCard(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }

        final data = snapshot.data?.data;
        if (data == null) {
          return _DarkCard(
            child: Text(
              'Failed to load details',
              style: TextStyles.font14whiteColorColorW400,
            ),
          );
        }

        return _DarkCard(
          child: Column(
            children: List.generate(4, (index) {
              final stepNumber = index + 1;
              return Padding(
                padding: EdgeInsets.only(bottom: index == 3 ? 0 : 14.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        OnboardingStepPresenter.title(stepNumber),
                        style: TextStyles.font14greyColorColor80W400,
                      ),
                    ),
                    horizontalSpace(12),
                    Flexible(
                      child: Text(
                        OnboardingStepPresenter.summary(
                          data.answerForStep(stepNumber),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyles.font14WhiteColorW500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Future<GetOnboardingStepResponseModel?> _loadStatus() async {
    final result = await getIt<LoginAndSignupRepo>().getOnboardingStatus();
    return result.fold((_) => null, (response) => response);
  }
}

class _ShoppingRow extends StatelessWidget {
  const _ShoppingRow({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: TextStyles.font16WhiteColorW600)),
        SizedBox(
          height: 34.h,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.blackColor,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: Text('View', style: TextStyles.font14BlackColorW700),
          ),
        ),
      ],
    );
  }
}

class _AccountTabs extends StatelessWidget {
  const _AccountTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: AppColors.greyColor27,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 16.r,
                  ),
                ],
              ),
              child: Text('Analytics', style: TextStyles.font14BlackColorW700),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Progress',
                style: TextStyles.font16WhiteColorW600.copyWith(
                  color: AppColors.greyColorColor80,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountActions extends StatelessWidget {
  const _AccountActions({
    required this.onLogout,
    required this.onRemoveAccount,
  });

  final VoidCallback onLogout;
  final VoidCallback onRemoveAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionButton(
          label: 'Log out',
          icon: Icons.logout,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.blackColor,
          onTap: onLogout,
        ),
        verticalSpace(18),
        _ActionButton(
          label: 'Remove account',
          icon: Icons.delete_outline,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.blackColor,
          onTap: onRemoveAccount,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20.r),
        label: Text(
          label,
          style: TextStyles.font16WhiteColorW600.copyWith(
            color: foregroundColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: backgroundColor, width: 1.2),
          ),
        ),
      ),
    );
  }
}
