class Body360FramePaths {
  const Body360FramePaths._();

  static const int frameCount = 4;
  static const String _basePath = 'assets/body_360/male/';

  static String framePath(int index) {
    final wrapped = ((index % frameCount) + frameCount) % frameCount;
    final padded = wrapped.toString().padLeft(3, '0');
    return '${_basePath}frame_$padded.webp';
  }
}
