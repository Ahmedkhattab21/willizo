class StepsRequestModel {
  final int? stepNumber;
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
  final List<int>? gymEquipmentIds;
  final List<int>? freeWeightIds;
  final List<int>? supportiveToolIds;

  StepsRequestModel({
    this.stepNumber,
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
    return {
      "step": stepNumber,
      "answer": {
        "name": name,
        "age": age,
        "gender": gender,
        "height": height,
        "weight": weight,
        "has_target_weight": hasTargetWeight,
        "target_weight": targetWeight,
        "primary_goal": primaryGoal,
        "days": days,
        "level": level,
        "workout": workout,
        "active_level": activeLevel,
        "has_health_issues": hasHealthIssues,
        "health_issues": healthIssues,
        "best_time_for_workout": betTimeForWorkout,
        "has_dietry": hasDietry,
        "choose_from_following_if_has_dietry_issues":
            chooseFromFollowingIfHasDietryIssues,
        "goal": goal,
        "is_allergic": isAllergic,
        "health_issues_description": healthIssuesDescription,
        "is_there_food_dislike": isThereFoodDislike,
        "food_dislike_description": foodDislikeDescription,
        "meals_per_day": mealsPerDay,
        "where_did_you_hear_about_us": whereDidYouHearAboutUs,
        "gym_equipment_ids": gymEquipmentIds,
        "free_weight_ids": freeWeightIds,
        "supportive_tool_ids": supportiveToolIds,
      },
    };
  }
}
