import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/community/data/models/sync_contacts_model.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/suggested_friend_card_widget.dart';

class FriendsFromYourContactsSection extends StatefulWidget {
  const FriendsFromYourContactsSection({super.key});

  @override
  State<FriendsFromYourContactsSection> createState() =>
      _FriendsFromYourContactsSectionState();
}

class _FriendsFromYourContactsSectionState
    extends State<FriendsFromYourContactsSection> {
  bool? _permissionGranted;
  bool _isRequesting = false;

  static const String _placeholderAvatarUrl =
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80';

  Future<void> _syncContactsToServer() async {
    if (!mounted) return;
    try {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      debugPrint('📱 [Contacts] Read from device: ${contacts.length} contacts');

      final items = <SyncContactItem>[];
      for (final c in contacts) {
        final name = c.displayName.trim();
        if (c.phones.isEmpty) continue;
        for (final phone in c.phones) {
          final number = phone.number.replaceAll(RegExp(r'[\s\-\(\)]'), '');
          if (number.isEmpty) continue;
          items.add(SyncContactItem(phoneNumber: number, name: name));
        }
      }

      if (items.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No contacts with phone numbers found.'),
            backgroundColor: AppColors.greyColor2727,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final request = SyncContactsRequest(contacts: items);
      if (mounted) {
        CommunityCubit.get(context).syncContacts(request);
      }
    } catch (e, st) {
      debugPrint('📥 [Sync Contacts] Exception: $e');
      debugPrint('$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to sync contacts.'),
            backgroundColor: AppColors.greyColor2727,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _requestContactsPermission() async {
    if (_isRequesting) return;
    setState(() => _isRequesting = true);

    final granted = await FlutterContacts.requestPermission(readonly: true);

    if (mounted) {
      setState(() {
        _permissionGranted = granted;
        _isRequesting = false;
      });
      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Contacts access was denied. You can allow it in Settings to find friends.',
            ),
            backgroundColor: AppColors.greyColor2727,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        if (CommunityCubit.get(context).suggestionsFromContacts.isEmpty) {
          _syncContactsToServer();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = CommunityCubit.get(context);
      if (cubit.suggestionsFromContacts.isNotEmpty) {
        setState(() => _permissionGranted = true);
        return;
      }
      if (_permissionGranted == null && !_isRequesting) {
        _requestContactsPermission();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommunityCubit, CommunityState>(
      listenWhen: (previous, current) =>
          current is ContactsSuggestionsErrorState,
      listener: (context, state) {
        if (state is ContactsSuggestionsErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              backgroundColor: AppColors.greyColor2727,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<CommunityCubit, CommunityState>(
        buildWhen: (previous, current) =>
            current is ContactsSuggestionsLoadingState ||
            current is ContactsSuggestionsLoadedState ||
            current is ContactsSuggestionsErrorState,
        builder: (context, state) {
          final isLoading =
              state is ContactsSuggestionsLoadingState;
          final list = state is ContactsSuggestionsLoadedState
              ? CommunityCubit.get(context).suggestionsFromContacts
              : null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Icon(Icons.phone,
                          color: AppColors.primaryColor, size: 24.sp),
                    ],
                  ),
                  horizontalSpace(8),
                  Text(
                    "From Your Contacts",
                    style: TextStyles.font18InterW400.copyWith(fontSize: 16.sp),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (_permissionGranted == false) {
                        _requestContactsPermission();
                      }
                    },
                    child: Text(
                      "See All",
                      style: TextStyles.font14primaryColorW600.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(8),
              Text(
                "Friends who joined recently",
                style: TextStyles.font14greyColorColor79W400.copyWith(
                  fontSize: 12.sp,
                ),
              ),
              verticalSpace(16),
              Divider(color: AppColors.greyColor3d, thickness: 1, height: 1),
              if (_permissionGranted == false) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Allow access to find friends from your contacts",
                          style: TextStyles.font14greyColorColor79W400.copyWith(
                            fontSize: 13.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        verticalSpace(12),
                        TextButton.icon(
                          onPressed:
                              _isRequesting ? null : _requestContactsPermission,
                          icon: Icon(
                            Icons.contacts,
                            size: 20.sp,
                            color: AppColors.primaryColor,
                          ),
                          label: Text(
                            "Allow access",
                            style: TextStyles.font14primaryColorW600,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                if (isLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: SizedBox(
                        width: 28.w,
                        height: 28.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  )
                else if (list != null)
                  if (list.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Center(
                        child: Text(
                          "No friends from contacts yet",
                          style: TextStyles.font14greyColorColor79W400.copyWith(
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    )
                  else
                    ...list.map(
                      (item) => SuggestedFriendCardWidget(
                        imageUrl: _placeholderAvatarUrl,
                        name: item.fullName,
                        subtitle: item.followersCount > 0
                            ? '${item.followersCount} followers'
                            : item.phoneNumber,
                      ),
                    )
                else
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: Text(
                        "No friends from contacts yet",
                        style: TextStyles.font14greyColorColor79W400.copyWith(
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
              ],
              verticalSpace(24),
            ],
          );
        },
      ),
    );
  }
}
