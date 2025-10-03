// button_nav_bar_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/features/button_nav_bar/data/nav_itme.dart';
import 'package:willizo/features/button_nav_bar/logic/cubit/button_nav_bar_state.dart';

class ButtonNavBarCubit extends Cubit<NavigationState> {
  ButtonNavBarCubit()
      : super(
          NavigationState(
            items: [
              NavItem(assetPath: ImageAsset.homeIcon, label: 'Home'),
              NavItem(assetPath: ImageAsset.dumbleIcon, label: 'Workout'),
              NavItem(assetPath: ImageAsset.shopIcon, label: 'Shop'),
              NavItem(assetPath: ImageAsset.communityIcon, label: 'Community'),
              NavItem(assetPath: ImageAsset.profileIcon, label: 'Account'),
            ],
            selectedIndex: 0,
            middleIndex: 2,
          ),
        );

  void selectItem(int index) {
    // Safety: guard out-of-range
    if (index < 0 || index >= state.items.length) return;
    // Just update selectedIndex (no swapping)
    emit(state.copyWith(selectedIndex: index));
  }
}
