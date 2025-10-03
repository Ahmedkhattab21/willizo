import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/features/account/ui/account_screen.dart';
import 'package:willizo/features/button_nav_bar/logic/cubit/button_nav_bar_cubit.dart';
import 'package:willizo/features/button_nav_bar/logic/cubit/button_nav_bar_state.dart';
import 'package:willizo/features/button_nav_bar/ui/widgets/eleveated_bottom_nav_bar.dart';
import 'package:willizo/features/community/ui/community_screen.dart';
import 'package:willizo/features/home/ui/home_screen.dart';
import 'package:willizo/features/shop/ui/shop_screen.dart';
import 'package:willizo/features/workout/ui/workout_screen.dart';

class ButtonNavBarWidget extends StatelessWidget {
  const ButtonNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ButtonNavBarCubit, NavigationState>(
        builder: (context, state) {
          return _getScreenForIndex(state.selectedIndex);
        },
      ),
      bottomNavigationBar: const ElevatedBottomNavBar(),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const WorkoutScreen();
      case 2:
        return const ShopScreen();
      case 3:
        return const CommunityScreen();
      case 4:
        return const AccountScreen();
      default:
        return const HomeScreen();
    }
  }
}
