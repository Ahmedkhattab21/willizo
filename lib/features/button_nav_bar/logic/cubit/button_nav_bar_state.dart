import 'package:equatable/equatable.dart';
import 'package:willizo/features/button_nav_bar/data/nav_itme.dart';

class NavigationState extends Equatable {
  final List<NavItem> items;
  final int selectedIndex;
  final int middleIndex;

  const NavigationState({
    required this.items,
    required this.selectedIndex,
    required this.middleIndex,
  });

  NavigationState copyWith({
    List<NavItem>? items,
    int? selectedIndex,
    int? middleIndex,
  }) {
    return NavigationState(
      items: items ?? this.items,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      middleIndex: middleIndex ?? this.middleIndex,
    );
  }

  @override
  List<Object?> get props => [items, selectedIndex, middleIndex];
}
