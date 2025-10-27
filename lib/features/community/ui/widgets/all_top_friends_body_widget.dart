import 'package:flutter/material.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/features/community/ui/widgets/top_friends_board_card.dart';

class TopFriendsContent extends StatelessWidget {
  const TopFriendsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 2, color: Colors.transparent),
                gradient: LinearGradient(
                  colors: [AppColors.greenColorEF, AppColors.greenColorFD],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF181C00),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 24,
                                width: 24,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.blueColorFB,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.group,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Top Friends",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Total Points",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.greyColorD1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.white, thickness: 1),
                    ListView.builder(
                      itemCount: 8,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return const FrindInfo();
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
