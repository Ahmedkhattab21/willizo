import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/features/account/ui/account_screen.dart';
import 'package:willizo/features/button_nav_bar/logic/cubit/button_nav_bar_cubit.dart';
import 'package:willizo/features/button_nav_bar/logic/cubit/button_nav_bar_state.dart';
import 'package:willizo/features/button_nav_bar/ui/widgets/eleveated_bottom_nav_bar.dart';
import 'package:willizo/features/community/ui/community_screen.dart';
import 'package:willizo/features/home/logic/cubit/home_cubit.dart';
import 'package:willizo/features/home/ui/home_screen.dart';
import 'package:willizo/features/shop/logic/cubit/badge_cubit.dart';
import 'package:willizo/features/shop/logic/cubit/categories_cubit.dart';
import 'package:willizo/features/shop/logic/cubit/shop_cubit.dart';
import 'package:willizo/features/shop/ui/shop_screen.dart';
import 'package:willizo/features/workout/ui/workout_screen.dart';

class ButtonNavBarWidget extends StatelessWidget {
  const ButtonNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocBuilder<ButtonNavBarCubit, NavigationState>(
        builder: (context, state) {
          return IndexedStack(
            index: state.selectedIndex.clamp(0, 4),
            children: _navScreens,
          );
        },
      ),
      bottomNavigationBar: const ElevatedBottomNavBar(),
    );
  }

  static final List<Widget> _navScreens = [
    BlocProvider(
      create: (context) => HomeCubit(getIt())..fetchPlans(),
      child: const HomeScreen(),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit(getIt())..getFeaturedProducts(),
        ),
        BlocProvider(
          create: (context) => CategoriesCubit(getIt())..getCategories(),
        ),
        BlocProvider.value(value: getIt<BadgeCubit>()..fetchBadgeCounts()),
      ],
      child: const ShopScreen(),
    ),
    const WorkoutScreen(),
    const CommunityScreen(),
    const AccountScreen(),
  ];
}
