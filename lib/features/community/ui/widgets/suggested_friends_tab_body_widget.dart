import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/features/community/logic/cubit/community_cubit.dart';
import 'package:willizo/features/community/ui/widgets/friends_from_your_contacts_section.dart';
import 'package:willizo/features/community/ui/widgets/friends_top_followers_sectoin.dart';
import 'package:willizo/features/community/ui/widgets/near_you_section.dart';

class SuggestedFriendsTabBodyWidget extends StatelessWidget {
  const SuggestedFriendsTabBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        color: AppColors.primaryColor,
        backgroundColor: AppColors.greyColor2727,
        onRefresh: () async {
          final cubit = context.read<CommunityCubit>();
          await Future.wait([
            cubit.getFriendsStats(),
            cubit.getSuggestionsNearYou(refresh: true),
            cubit.getSuggestionsFromContacts(),
            cubit.getTopFollowers(refresh: true),
          ]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            const NearYouSection(),
            const FriendsFromYourContactsSection(),
            const FriendsTopFollowersSection(),
          ],
        ),
      ),
    );
  }
}
