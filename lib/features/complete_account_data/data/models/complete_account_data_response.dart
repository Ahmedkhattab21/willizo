class StepResponseModel {
  final bool success;
  final String message;
  final StepData? data;

  StepResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory StepResponseModel.fromJson(Map<String, dynamic> json) {
    return StepResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? StepData.fromJson(json['data']) : null,
    );
  }
}

class StepData {
  final int? currentStep;
  final int? totalSteps;
  final Map<String, dynamic>? answers;
  final bool? isCompleted;
  final double? progressPercentage;
  final String? createdAt;
  final String? updatedAt;

  StepData({
    this.currentStep,
    this.totalSteps,
    this.answers,
    this.isCompleted,
    this.progressPercentage,
    this.createdAt,
    this.updatedAt,
  });

  factory StepData.fromJson(Map<String, dynamic> json) {
    return StepData(
      currentStep: json['current_step'],
      totalSteps: json['total_steps'],
      answers: json['answers'] != null
          ? Map<String, dynamic>.from(json['answers'])
          : null,
      isCompleted: json['is_completed'],
      progressPercentage: (json['progress_percentage'] as num?)?.toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
