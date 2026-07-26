import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/features/community/data/models/friend_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/friends_list_shimmer_widget.dart';
import 'package:willizo/features/community/ui/widgets/frind_info_card_widget.dart';
import 'package:willizo/features/community/ui/widgets/remove_friend_dialog.dart';

/// Placeholder avatar when API does not provide image.
const String _placeholderAvatarUrl =
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80';

class FriendsListWidget extends StatefulWidget {
  const FriendsListWidget({super.key});

  @override
  State<FriendsListWidget> createState() => _FriendsListWidgetState();
}

class _FriendsListWidgetState extends State<FriendsListWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _requestedFriends = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<CommunityCubit>();
    if (cubit.state is! FriendsLoadedState &&
        cubit.state is! FriendsLoadingMoreState) {
      return;
    }
    if (!cubit.hasMoreFriends) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      cubit.loadMoreFriends();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        // Request friends once when All Friends tab is first shown.
        if (!_requestedFriends) {
          _requestedFriends = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              final cubit = context.read<CommunityCubit>();
              if (state is! FriendsLoadingState &&
                  state is! FriendsLoadedState &&
                  state is! FriendsLoadingMoreState &&
                  state is! FriendsErrorState) {
                cubit.getFriends();
              }
            }
          });
        }

        if (state is FriendsLoadingState ||
            (state is! FriendsLoadedState &&
                state is! FriendsLoadingMoreState &&
                state is! FriendsErrorState)) {
          return const Expanded(
            child: SingleChildScrollView(child: FriendsListShimmerWidget()),
          );
        }
        if (state is FriendsErrorState) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.failure.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.read<CommunityCubit>().getFriends(
                      refresh: true,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final friends = state is FriendsLoadedState
            ? state.friends
            : state is FriendsLoadingMoreState
            ? state.friends
            : <FriendListItem>[];

        if (friends.isEmpty) {
          return Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryColor,
              backgroundColor: AppColors.greyColor2727,
              onRefresh: () =>
                  context.read<CommunityCubit>().getFriends(refresh: true),
              child: const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 280,
                  child: Center(child: Text('No friends yet')),
                ),
              ),
            ),
          );
        }

        final isLoadingMore = state is FriendsLoadingMoreState;

        return Expanded(
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: AppColors.greyColor2727,
            onRefresh: () =>
                context.read<CommunityCubit>().getFriends(refresh: true),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: friends.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= friends.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = friends[index];
                final f = item.friend;

                String activeStatus = 'Inactive';
                bool isOnline = false;

                if (f.lastActiveAt != null && f.lastActiveAt!.isNotEmpty) {
                  try {
                    String dateString = f.lastActiveAt!;
                    if (!dateString.contains('Z')) {
                      dateString = '${dateString.replaceFirst(' ', 'T')}Z';
                    }
                    final lastActive = DateTime.tryParse(dateString);
                    if (lastActive != null) {
                      final now = DateTime.now().toUtc();
                      final difference = now.difference(lastActive);

                      if (difference.isNegative || difference.inMinutes < 1) {
                        activeStatus = 'Active now';
                        isOnline = true;
                      } else if (difference.inMinutes < 60) {
                        activeStatus = 'Active ${difference.inMinutes} min ago';
                        isOnline = true;
                      } else if (difference.inHours < 24) {
                        activeStatus =
                            'Last workout ${difference.inHours}h ago';
                        isOnline = false;
                      } else {
                        activeStatus = 'Last workout ${difference.inDays}d ago';
                        isOnline = false;
                      }
                    }
                  } catch (e) {
                    activeStatus = 'Inactive';
                    isOnline = false;
                  }
                }

                return FriendInfoCardWidget(
                  name: f.fullName,
                  activeStatus: activeStatus,
                  isActiveNow: isOnline,
                  currentActivity: f.currentActivity,
                  imageUrl: _placeholderAvatarUrl,
                  onRemoveTap: () => showRemoveFriendDialog(
                    context: context,
                    cubit: context.read<CommunityCubit>(),
                    friendId: item.id,
                    friendName: f.fullName,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
