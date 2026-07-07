class StepsRequestModel {
  final int stepNumber;
  final String? name;
  final int? age;
  final String? gender;
  final String? height;
  final String? weight;
  final bool? hasTargetWeight;
  final int? targetWeight;
  final List<String>? primaryGoal;
  final List<String>? days;
  final String? level;
  final String? workout;
  final String? activeLevel;
  final bool? hasHealthIssues;
  final String? healthIssues;
  final String? betTimeForWorkout;
  final bool? hasDietry;
  final String? chooseFromFollowingIfHasDietryIssues;
  final String? goal;
  final bool? isAllergic;
  final String? healthIssuesDescription;
  final bool? isThereFoodDislike;
  final String? foodDislikeDescription;
  final int? mealsPerDay;
  final String? whereDidYouHearAboutUs;
  final List<String>? gymEquipmentIds;
  final List<String>? freeWeightIds;
  final List<String>? supportiveToolIds;

  StepsRequestModel({
    required this.stepNumber,
    this.name,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.hasTargetWeight,
    this.targetWeight,
    this.primaryGoal,
    this.days,
    this.level,
    this.workout,
    this.activeLevel,
    this.hasHealthIssues,
    this.healthIssues,
    this.betTimeForWorkout,
    this.hasDietry,
    this.chooseFromFollowingIfHasDietryIssues,
    this.goal,
    this.isAllergic,
    this.healthIssuesDescription,
    this.isThereFoodDislike,
    this.foodDislikeDescription,
    this.mealsPerDay,
    this.whereDidYouHearAboutUs,
    this.gymEquipmentIds,
    this.freeWeightIds,
    this.supportiveToolIds,
  });

  Map<String, dynamic> toJson() {
    final answer = <String, dynamic>{};

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        answer[key] = value;
      }
    }

    addIfNotNull("name", name);
    addIfNotNull("age", age);
    addIfNotNull("gender", gender);
    addIfNotNull("height", height);
    addIfNotNull("weight", weight);

    addIfNotNull("has_target_weight", hasTargetWeight);
    addIfNotNull("target_weight", targetWeight);
    addIfNotNull("primary_goal", primaryGoal);
    addIfNotNull("days", days);
    addIfNotNull("level", level);
    addIfNotNull("workout", workout);
    addIfNotNull("active_level", activeLevel);
    addIfNotNull("has_health_issues", hasHealthIssues);
    addIfNotNull("health_issues", healthIssues);
    addIfNotNull("best_time_for_workout", betTimeForWorkout);
    addIfNotNull("has_dietry", hasDietry);
    addIfNotNull(
      "choose_from_following_if_has_dietry_issues",
      chooseFromFollowingIfHasDietryIssues,
    );
    addIfNotNull("goal", goal);
    addIfNotNull("is_allergic", isAllergic);
    addIfNotNull("health_issues_description", healthIssuesDescription);
    addIfNotNull("is_there_food_dislike", isThereFoodDislike);
    addIfNotNull("food_dislike_description", foodDislikeDescription);
    addIfNotNull("meals_per_day", mealsPerDay);
    addIfNotNull("where_did_you_hear_about_us", whereDidYouHearAboutUs);
    addIfNotNull("gym_equipment_ids", gymEquipmentIds);
    addIfNotNull("free_weight_ids", freeWeightIds);
    addIfNotNull("supportive_tool_ids", supportiveToolIds);

    return {"step": stepNumber, "answer": answer};
  }
}
