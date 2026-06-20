import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:willizo/features/workout/ui/widgets/exercises/body_360/muscle_hotspot_model.dart';

class Body360HotspotLoader {
  const Body360HotspotLoader._();

  static const String _hotspotsPath = 'assets/body_360/hotspots.json';

  static Future<Map<int, List<MuscleHotspot>>> load() async {
    final raw = await rootBundle.loadString(_hotspotsPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return const {};

    final result = <int, List<MuscleHotspot>>{};
    for (final entry in decoded.entries) {
      final frame = int.tryParse(entry.key.toString());
      if (frame == null) continue;
      final value = entry.value;
      if (value is! List) continue;
      result[frame] = value
          .map((e) => MuscleHotspot.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    }
    return result;
  }
}
