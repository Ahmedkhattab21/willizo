import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:willizo/core/utils/app_colors_white_theme.dart';
import 'package:willizo/core/utils/spacing.dart';
import 'package:willizo/core/utils/styles.dart';
import 'package:willizo/features/workout/data/models/body_parts_response_model.dart';
import 'package:willizo/features/workout/ui/muscle_exercises_screen.dart';
import 'package:willizo/features/workout/ui/widgets/exercises/body_360/body_360_frame_paths.dart';
import 'package:willizo/features/workout/ui/widgets/exercises/body_360/body_360_hotspot_loader.dart';
import 'package:willizo/features/workout/ui/widgets/exercises/body_360/hotspot_slug_mapper.dart';
import 'package:willizo/features/workout/ui/widgets/exercises/body_360/muscle_hotspot_model.dart';

class Body360Viewer extends StatefulWidget {
  const Body360Viewer({
    super.key,
    this.bodyPartGroups = const [],
  });

  final List<BodyPartModel> bodyPartGroups;

  @override
  State<Body360Viewer> createState() => _Body360ViewerState();
}

class _Body360ViewerState extends State<Body360Viewer> {
  static const double _viewerWidth = 375;
  static const double _viewerHeight = 520;

  final TransformationController _transformController =
      TransformationController();
  final Map<int, List<MuscleHotspot>> _hotspotsByFrame = {};

  int _currentFrame = 0;
  double _dragAccumulator = 0;
  MuscleHotspot? _selectedHotspot;
  BodyPartChildModel? _selectedChild;
  String? _selectedCategory;
  bool _hotspotsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadHotspots();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var i = 0; i < Body360FramePaths.frameCount; i++) {
      precacheImage(AssetImage(Body360FramePaths.framePath(i)), context);
    }
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  Future<void> _loadHotspots() async {
    final loaded = await Body360HotspotLoader.load();
    if (!mounted) return;
    setState(() {
      _hotspotsByFrame
        ..clear()
        ..addAll(loaded);
      _hotspotsLoaded = true;
    });
  }

  List<MuscleHotspot> get _currentHotspots =>
      _hotspotsByFrame[_currentFrame] ?? const [];

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final scale = _transformController.value.getMaxScaleOnAxis();
    if (scale > 1.05) return;

    _dragAccumulator += details.delta.dx;
    if (_dragAccumulator.abs() < 8) return;

    final direction = _dragAccumulator < 0 ? 1 : -1;
    setState(() {
      _currentFrame = _wrapFrame(_currentFrame + direction);
      _selectedHotspot = null;
      _selectedChild = null;
      _selectedCategory = null;
    });
    _dragAccumulator = 0;
  }

  int _wrapFrame(int value) {
    final frameCount = Body360FramePaths.frameCount;
    return (value % frameCount + frameCount) % frameCount;
  }

  void _selectHotspot(MuscleHotspot hotspot) {
    final slug = HotspotSlugMapper.toBodyPartSlug(hotspot.id);
    final match = _findMuscleBySlug(slug);

    setState(() {
      _selectedHotspot = hotspot;
      _selectedChild = match?.child;
      _selectedCategory = match?.groupName ?? _fallbackCategoryFor(hotspot.id);
    });

    _zoomToHotspot(hotspot);
  }

  _MuscleMatch? _findMuscleBySlug(String? slug) {
    if (slug == null || slug.isEmpty) return null;
    for (final group in widget.bodyPartGroups) {
      for (final child in group.children) {
        if (child.slug == slug) {
          return _MuscleMatch(child: child, groupName: group.name);
        }
      }
    }
    return null;
  }

  String _fallbackCategoryFor(String hotspotId) {
    switch (hotspotId) {
      case 'chest':
      case 'chest_side':
      case 'shoulders':
      case 'shoulder_side':
      case 'rear_shoulders':
      case 'arm':
      case 'traps':
        return 'Upper Body';
      case 'abs':
      case 'obliques':
        return 'Core';
      case 'quads':
      case 'leg_side':
      case 'hamstrings':
      case 'calves':
      case 'calves_back':
        return 'Lower Body';
      case 'back':
        return 'Back';
      default:
        return 'Muscle';
    }
  }

  void _zoomToHotspot(MuscleHotspot hotspot) {
    const scale = 2.2;
    final centerX = (hotspot.x + hotspot.w / 2) * _viewerWidth;
    final centerY = (hotspot.y + hotspot.h / 2) * _viewerHeight;

    final dx = -(centerX * scale) + (_viewerWidth / 2);
    final dy = -(centerY * scale) + (_viewerHeight / 2);

    _transformController.value = Matrix4.diagonal3Values(scale, scale, 1)
      ..setTranslationRaw(dx, dy, 0);
  }

  void _resetZoom() {
    setState(() {
      _transformController.value = Matrix4.identity();
      _selectedHotspot = null;
      _selectedChild = null;
      _selectedCategory = null;
    });
  }

  void _openSelectedMuscle() {
    final child = _selectedChild;
    if (child == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MuscleExercisesScreen(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onDoubleTap: _resetZoom,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            child: Center(
              child: InteractiveViewer(
                transformationController: _transformController,
                minScale: 1,
                maxScale: 4,
                boundaryMargin: const EdgeInsets.all(120),
                child: SizedBox(
                  width: _viewerWidth.w,
                  height: _viewerHeight.h,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          Body360FramePaths.framePath(_currentFrame),
                          fit: BoxFit.contain,
                        ),
                      ),
                      ..._currentHotspots.map((hotspot) {
                        final isSelected = _selectedHotspot?.id == hotspot.id;
                        return Positioned(
                          left: hotspot.x * _viewerWidth.w,
                          top: hotspot.y * _viewerHeight.h,
                          width: hotspot.w * _viewerWidth.w,
                          height: hotspot.h * _viewerHeight.h,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => _selectHotspot(hotspot),
                            child: Center(
                              child: _HotspotPin(isSelected: isSelected),
                            ),
                          ),
                        );
                      }),
                      if (_selectedHotspot != null)
                        ..._buildSelectedCallout(_selectedHotspot!, isArabic),
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blackColor.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '${_currentFrame + 1}/${Body360FramePaths.frameCount}',
                            style: TextStyles.font12whiteColorColorW400
                                .copyWith(fontSize: 11.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        verticalSpace(4),
        Text(
          '< Drag to rotate · Pinch to zoom >',
          style: TextStyles.font14GreyColorW400.copyWith(fontSize: 11.sp),
        ),
        if (_selectedChild != null) ...[
          verticalSpace(4),
          TextButton(
            onPressed: _openSelectedMuscle,
            child: Text(
              'View exercises',
              style: TextStyles.font14W700.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ] else if (_hotspotsLoaded) ...[
          verticalSpace(8),
        ] else ...[
          verticalSpace(4),
          const SizedBox(
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryColor,
            ),
          ),
          verticalSpace(4),
        ],
      ],
    );
  }

  List<Widget> _buildSelectedCallout(MuscleHotspot hotspot, bool isArabic) {
    final centerX = (hotspot.x + hotspot.w / 2) * _viewerWidth.w;
    final centerY = (hotspot.y + hotspot.h / 2) * _viewerHeight.h;

    final showRight = centerX < (_viewerWidth.w * 0.5);
    const boxMaxWidth = 90.0;
    final lineTopY = (centerY - 28.h).clamp(8.h, _viewerHeight.h - 24.h);

    final labelLeft = showRight
        ? centerX + 36.w
        : centerX - 36.w - boxMaxWidth.w;
    final labelTop = lineTopY - 8.h;
    final lineEndX = showRight ? labelLeft : labelLeft + boxMaxWidth.w;
    final displayName = isArabic ? hotspot.nameAr : hotspot.nameEn;
    final category = _selectedCategory ?? '';

    return [
      Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(
            painter: _DashedElbowPainter(
              start: Offset(centerX, centerY),
              elbow: Offset(centerX, lineTopY),
              end: Offset(lineEndX, lineTopY),
            ),
          ),
        ),
      ),
      Positioned(
        left: labelLeft,
        top: labelTop,
        child: Container(
          constraints: BoxConstraints(maxWidth: boxMaxWidth.w),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: const Color(0xFF101416),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.75),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.whiteColor.withValues(alpha: 0.75),
                  fontSize: 8.5.sp,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

class _HotspotPin extends StatelessWidget {
  const _HotspotPin({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSelected ? 18.w : 14.w,
      height: isSelected ? 18.w : 14.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF131313),
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
      child: Center(
        child: Container(
          width: isSelected ? 6.w : 4.w,
          height: isSelected ? 6.w : 4.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}

class _DashedElbowPainter extends CustomPainter {
  const _DashedElbowPainter({
    required this.start,
    required this.elbow,
    required this.end,
  });

  final Offset start;
  final Offset elbow;
  final Offset end;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor.withValues(alpha: 0.9)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _drawDashedLine(canvas, paint, start, elbow);
    _drawDashedLine(canvas, paint, elbow, end);
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset a, Offset b) {
    final delta = b - a;
    final distance = delta.distance;
    if (distance <= 0) return;

    const dash = 5.0;
    const gap = 3.0;
    final direction = Offset(delta.dx / distance, delta.dy / distance);

    double current = 0;
    while (current < distance) {
      final dashStart = Offset(
        a.dx + direction.dx * current,
        a.dy + direction.dy * current,
      );
      final dashEndDistance = (current + dash).clamp(0, distance);
      final dashEnd = Offset(
        a.dx + direction.dx * dashEndDistance,
        a.dy + direction.dy * dashEndDistance,
      );
      canvas.drawLine(dashStart, dashEnd, paint);
      current += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedElbowPainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.elbow != elbow ||
        oldDelegate.end != end;
  }
}

class _MuscleMatch {
  const _MuscleMatch({required this.child, required this.groupName});

  final BodyPartChildModel child;
  final String groupName;
}
