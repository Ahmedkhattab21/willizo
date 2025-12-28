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
              NavItem(
                activeAssetPath: ImageAsset.activeHomeIcon,
                inactiveAssetPath: ImageAsset.inactiveHomeIcon,
                label: 'Home',
              ),
              NavItem(
                activeAssetPath: ImageAsset.activeShopIcon,
                inactiveAssetPath: ImageAsset.activeInactiveShopIcon,
                label: 'Shop',
              ),
              NavItem(
                activeAssetPath: ImageAsset.activeGymIcon,
                inactiveAssetPath: ImageAsset.inactiveGymIcon,
                label: 'Workout',
              ),
              NavItem(
                activeAssetPath: ImageAsset.activeRankingIcon,
                inactiveAssetPath: ImageAsset.inactiveRankingIcon,
                label: 'Ranking',
              ),
              NavItem(
                activeAssetPath: ImageAsset.activeProfileIcon,
                inactiveAssetPath: ImageAsset.inactiveProfileIcon,
                label: 'Account',
              ),
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
