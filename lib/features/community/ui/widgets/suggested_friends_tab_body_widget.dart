import 'package:flutter/material.dart';
import 'package:willizo/features/community/ui/widgets/friends_from_your_contacts_section.dart';
import 'package:willizo/features/community/ui/widgets/friends_top_followers_sectoin.dart';
import 'package:willizo/features/community/ui/widgets/near_you_section.dart';

class SuggestedFriendsTabBodyWidget extends StatelessWidget {
  const SuggestedFriendsTabBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const NearYouSection(),
          const FriendsFromYourContactsSection(),
          const FriendsTopFollowersSection(),
        ],
      ),
    );
  }
}
