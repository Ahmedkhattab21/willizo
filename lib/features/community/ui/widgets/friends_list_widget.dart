import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/community/data/models/friend_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/frind_info_card_widget.dart';

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
        cubit.state is! FriendsLoadingMoreState) return;
    if (!cubit.hasMoreFriends) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      cubit.loadMoreFriends();
    }
  }

  static String _activeStatus(Friend friend) {
    if (friend.isActiveNow && friend.currentActivity != null) {
      return 'Active now · ${friend.currentActivity}';
    }
    if (friend.lastActiveAt != null && friend.lastActiveAt!.isNotEmpty) {
      return 'Last active ${friend.lastActiveAt}';
    }
    return 'Inactive';
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
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FriendsErrorState) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.failure.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () =>
                        context.read<CommunityCubit>().getFriends(refresh: true),
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
          return const Center(child: Text('No friends yet'));
        }

        final isLoadingMore = state is FriendsLoadingMoreState;

        return Expanded(
          child: ListView.builder(
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
              return FriendInfoCardWidget(
                name: f.fullName,
                activeStatus: _activeStatus(f),
                isActiveNow: f.isActiveNow,
                imageUrl: _placeholderAvatarUrl,
              );
            },
          ),
        );
      },
    );
  }
}
