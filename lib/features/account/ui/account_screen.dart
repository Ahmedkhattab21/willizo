import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/account/data/repo/account_repo.dart';
import 'package:willizo/features/account/logic/cubit/account_cubit.dart';
import 'package:willizo/features/account/ui/widgets/infro_tile_widget.dart';
import 'package:willizo/features/account/ui/widgets/account_shimmer_widget.dart';
import 'package:willizo/features/account/ui/widgets/profile_header_widget.dart';
import 'package:willizo/features/account/ui/widgets/subscription_card_widget.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountCubit(getIt<AccountRepo>())..getAccountData(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: BlocBuilder<AccountCubit, AccountState>(
            builder: (context, state) {
              if (state is FetchAccountLoadingState) {
                return const AccountShimmerWidget();
              }

              if (state is FetchAccountErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.message}',
                        style: TextStyles.font14whiteColorColorW400,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AccountCubit>().getAccountData();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final accountData = state is FetchAccountLoadedState
                  ? state.accountData.data
                  : null;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: SvgPicture.asset(ImageAsset.arrowBackIcon),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'ACCOUNT',
                                style: TextStyles.font14BebasNeueW400.copyWith(
                                  fontSize: 24.sp,
                                ),
                              ),
                            ),
                          ),
                          horizontalSpace(40),
                        ],
                      ),
                      verticalSpace(12),
                      ProfileHeader(
                        name: accountData?.name ?? 'Loading...',
                        email: accountData?.email ?? 'Loading...',
                      ),
                      verticalSpace(18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Personal Info',
                                  style: TextStyles.font14whiteColorColorW400
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                                SvgPicture.asset(
                                  ImageAsset.editIcon,
                                  width: 20.w,
                                  height: 20.h,
                                ),
                              ],
                            ),
                            verticalSpace(20),
                            Wrap(
                              spacing: 12,
                              runSpacing: 10,
                              children: [
                                InfoTile(
                                  label: 'Name',
                                  value: accountData?.name ?? 'N/A',
                                ),
                                InfoTile(
                                  label: 'Phone',
                                  value: accountData?.phoneNumber ?? 'N/A',
                                ),
                                InfoTile(
                                  label: 'Email',
                                  value: accountData?.email ?? 'N/A',
                                ),
                                InfoTile(label: 'Gender', value: 'male'),
                                InfoTile(label: 'Height', value: '172 cm'),
                                InfoTile(label: 'Weight', value: '72.4 kg'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: const SubscriptionCard(),
                      ),
                      verticalSpace(18),
                      Text('Workouts', style: TextStyles.font16WhiteColorW500),
                      verticalSpace(8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '12',
                                      style: TextStyles.fon32whiteColorW700,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Last 7 days • +10%',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // const SizedBox(height: 12),
                            // const SizedBox(height: 160, child: NeonChart()),
                          ],
                        ),
                      ),
                      verticalSpace(24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
