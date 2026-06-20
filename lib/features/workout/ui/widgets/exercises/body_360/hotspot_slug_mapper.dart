class HotspotSlugMapper {
  const HotspotSlugMapper._();

  static String? toBodyPartSlug(String hotspotId) {
    switch (hotspotId) {
      case 'chest':
      case 'chest_side':
        return 'chest';
      case 'abs':
        return 'abs';
      case 'back':
        return 'back';
      case 'quads':
      case 'leg_side':
        return 'quads';
      case 'hamstrings':
        return 'hamstrings';
      case 'calves':
      case 'calves_back':
        return 'calves';
      case 'arm':
        return 'arms';
      default:
        return null;
    }
  }
}
