class StepsResponseModel {
  final bool status;
  final String message;
  final StepsData? data;

  StepsResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory StepsResponseModel.fromJson(Map<String, dynamic> json) {
    return StepsResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? StepsData.fromJson(json['data']) : null,
    );
  }
}

class StepsData {
  final int dailyStepTarget;
  final int caloriesTarget;
  final double distanceTargetKm;

  StepsData({
    required this.dailyStepTarget,
    required this.caloriesTarget,
    required this.distanceTargetKm,
  });

  factory StepsData.fromJson(Map<String, dynamic> json) {
    return StepsData(
      dailyStepTarget: json['daily_step_target'] ?? 0,
      caloriesTarget: json['calories_target'] ?? 0,
      distanceTargetKm:
          (json['distance_target_km'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "daily_step_target": dailyStepTarget,
      "calories_target": caloriesTarget,
      "distance_target_km": distanceTargetKm,
    };
  }
}
