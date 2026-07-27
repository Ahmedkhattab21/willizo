import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/data/models/friend_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';

class FriendRequestsTabBodyWidget extends StatefulWidget {
  const FriendRequestsTabBodyWidget({super.key});

  @override
  State<FriendRequestsTabBodyWidget> createState() =>
      _FriendRequestsTabBodyWidgetState();
}

class _FriendRequestsTabBodyWidgetState
    extends State<FriendRequestsTabBodyWidget> {
  bool _requested = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<CommunityCubit, CommunityState>(
        listenWhen: (_, state) => state is FriendRequestActionErrorState,
        listener: (context, state) {
          if (state is FriendRequestActionErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        buildWhen: (_, state) =>
            state is FriendRequestsLoadingState ||
            state is FriendRequestsLoadedState ||
            state is FriendRequestsErrorState ||
            state is FriendRequestActionLoadingState ||
            state is FriendRequestActionErrorState,
        builder: (context, state) {
          final cubit = context.read<CommunityCubit>();
          if (!_requested) {
            _requested = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                cubit.getFriendRequests();
              }
            });
          }

          final loadingId = state is FriendRequestActionLoadingState
              ? state.requestId
              : null;
          final requests = cubit.friendRequests;

          if (state is FriendRequestsLoadingState && requests.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is FriendRequestsErrorState) {
            return _RequestsMessage(
              message: state.failure.message,
              onRetry: () => cubit.getFriendRequests(refresh: true),
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: AppColors.greyColor2727,
            onRefresh: () async {
              await Future.wait([
                cubit.getFriendRequests(refresh: true),
                cubit.getFriendsStats(),
              ]);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
                    child: Text(
                      "${requests.length} pending requests",
                      style: TextStyles.font12greyColorColor79W400.copyWith(
                        color: AppColors.greyColor75,
                      ),
                    ),
                  ),
                ),
                if (requests.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyRequestsView(),
                  )
                else
                  SliverList.separated(
                    itemCount: requests.length,
                    separatorBuilder: (_, __) => Divider(
                      color: AppColors.greyColor3d.withValues(alpha: 0.55),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return _FriendRequestItem(
                        request: request,
                        isLoading: loadingId == request.id,
                        onAccept: () => cubit.acceptFriendRequest(request.id),
                        onReject: () => cubit.rejectFriendRequest(request.id),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FriendRequestItem extends StatelessWidget {
  final FriendListItem request;
  final bool isLoading;
  final Future<bool> Function() onAccept;
  final Future<bool> Function() onReject;

  const _FriendRequestItem({
    required this.request,
    required this.isLoading,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final friend = request.friend;
    final subtitle = friend.currentActivity?.isNotEmpty == true
        ? friend.currentActivity!
        : friend.friendId?.isNotEmpty == true
        ? 'Friend ID: ${friend.friendId}'
        : friend.email;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.greyColor3d,
                backgroundImage: friend.profilePhoto != null
                    ? NetworkImage(friend.profilePhoto!)
                    : null,
                child: friend.profilePhoto == null
                    ? Icon(
                        Icons.person,
                        color: AppColors.whiteColor,
                        size: 22.sp,
                      )
                    : null,
              ),
              if (friend.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 13.w,
                    height: 13.w,
                    decoration: BoxDecoration(
                      color: AppColors.greenColor12,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.blackColor, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.fullName.isNotEmpty ? friend.fullName : 'Unknown',
                  style: TextStyles.font14InterW600.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                verticalSpace(3),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyles.font12greyColorColor79W400.copyWith(
                      color: AppColors.greyColor75,
                    ),
                  ),
              ],
            ),
          ),
          horizontalSpace(10),
          if (isLoading)
            SizedBox(
              width: 34.w,
              height: 34.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryColor,
              ),
            )
          else ...[
            _RequestActionButton(
              icon: Icons.check,
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.blackColor,
              onTap: onAccept,
            ),
            horizontalSpace(8),
            _RequestActionButton(
              icon: Icons.close,
              backgroundColor: AppColors.greyColor2727,
              foregroundColor: AppColors.whiteColor,
              onTap: onReject,
            ),
          ],
        ],
      ),
    );
  }
}

class _RequestActionButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Future<bool> Function() onTap;

  const _RequestActionButton({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: foregroundColor, size: 22.sp),
      ),
    );
  }
}

class _EmptyRequestsView extends StatelessWidget {
  const _EmptyRequestsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            decoration: const BoxDecoration(
              color: AppColors.greyColor2727,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add_alt_1_outlined,
              color: AppColors.greyColor75,
              size: 28.sp,
            ),
          ),
          verticalSpace(18),
          Text(
            "No pending requests",
            style: TextStyles.font14InterW600.copyWith(
              color: AppColors.whiteColor,
              fontSize: 16.sp,
            ),
          ),
          verticalSpace(6),
          Text(
            "You're all caught up.",
            style: TextStyles.font12greyColorColor79W400.copyWith(
              color: AppColors.greyColor75,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestsMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _RequestsMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.font14whiteColorColorW400,
            ),
            verticalSpace(12),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
