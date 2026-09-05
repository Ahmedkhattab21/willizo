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
      case 'chest-bench':
      case 'push-ups':
      case 'pull-ups':
        return ImageAsset.dumbleFillIcon;
      case 'squat':
        return ImageAsset.squatsIcon;
      case 'plank':
        return ImageAsset.plankIcon;
      case 'overhead-press':
        return ImageAsset.overheadPressIcon;
      case 'bicep-curl':
      case 'tricep-dip':
      case 'burpees':
      case 'climbers':
        return ImageAsset.coloredDoumble;
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
