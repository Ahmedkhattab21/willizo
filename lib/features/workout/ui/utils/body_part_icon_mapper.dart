import 'package:willizo/core/utils/assets_manager.dart';

class BodyPartIconMapper {
  const BodyPartIconMapper._();

  static String assetForGroup(String icon) {
    switch (icon) {
      case 'dumbbell':
        return ImageAsset.dumbleFillIcon;
      case 'flame':
        return ImageAsset.coreIcon;
      case 'running':
        return ImageAsset.lowerBodyIcon;
      case 'heart-pulse':
        return ImageAsset.cardioIcon;
      default:
        return ImageAsset.dumbleFillIcon;
    }
  }

  static String assetForMuscle(String icon) {
    switch (icon) {
      case 'chest':
      case 'back':
      case 'lats':
      case 'arms':
      case 'biceps':
      case 'triceps':
        return ImageAsset.dumbleFillIcon;
      case 'abs':
      case 'obliques':
        return ImageAsset.coreIcon;
      case 'quads':
      case 'hamstrings':
      case 'glutes':
      case 'calves':
        return ImageAsset.lowerBodyIcon;
      default:
        return ImageAsset.coloredDoumble;
    }
  }
}
