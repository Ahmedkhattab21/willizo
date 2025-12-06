import 'package:flutter/material.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Plan Card
                _buildPremiumCard(),
                const SizedBox(height: 32),

                // Current Members Section
                const Text(
                  'Current Members',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildMembersList(),
                const SizedBox(height: 32),

                // Add New Members Section
                const Text(
                  'Add New Members',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInviteButtons(),
                const SizedBox(height: 32),

                // Plan Settings Section
                const Text(
                  'Plan Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Plan Sittings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                _buildPlanSettings(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF44EF91), Color(0xFFD9FF0A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Family Plan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Active since Jan 2024',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.group, color: Colors.black87, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$14.99/month',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Up to 6 members',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Members',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '3/6',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    return Column(
      children: [
        _buildMemberItem(
          name: 'Sarah Johnson',
          subtitle: 'Plan Owner',
          isOwner: true,
          avatarColor: Colors.pink.shade100,
          isOnline: true,
        ),
        const Divider(height: 1),
        _buildMemberItem(
          name: 'Mike Chen',
          subtitle: 'Active 5 min ago',
          isOwner: false,
          avatarColor: Colors.blue.shade100,
          isOnline: true,
        ),
        const Divider(height: 1),
        _buildMemberItem(
          name: 'Emma Wilson',
          subtitle: 'Last seen 1h ago',
          isOwner: false,
          avatarColor: Colors.purple.shade100,
          isOnline: false,
        ),
      ],
    );
  }

  Widget _buildMemberItem({
    required String name,
    required String subtitle,
    required bool isOwner,
    required Color avatarColor,
    required bool isOnline,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: avatarColor,
                child: Icon(Icons.person, color: Colors.white, size: 28),
              ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF44EF91),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          if (isOwner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF44EF91).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Owner',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00A86B),
                ),
              ),
            )
          else
            Icon(
              Icons.person_add_alt_outlined,
              color: Colors.grey.shade400,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildInviteButtons() {
    return Column(
      children: [
        // Invite by Email Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF44EF91), Color(0xFFD9FF0A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(28),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20, color: Colors.black87),
                    SizedBox(width: 8),
                    Text(
                      'Invite by Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Share Invite Link Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF44EF91), Color(0xFFD9FF0A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Container(
            margin: const EdgeInsets.all(2), // Border width
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(26),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.link, size: 20, color: AppColors.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Share Invite Link',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanSettings(BuildContext context) {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () {},
        ),
        const Divider(height: 1),
        _buildSettingItem(
          icon: Icons.credit_card_outlined,
          title: 'Billing',
          onTap: () {
            Navigator.pushNamed(context, Routes.billingScreen);
          },
        ),
        const Divider(height: 1),
        _buildSettingItem(
          icon: Icons.info_outline,
          title: 'Plan Details',
          onTap: () {
            Navigator.pushNamed(context, Routes.planDetailsScreen);
          },
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
          ],
        ),
      ),
    );
  }
}
