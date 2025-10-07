class StepsRequestModel {
  final int height; // in cm
  final int weight; // in kg
  final int age;
  final String gender; // "male" or "female"
  final String goal; // e.g., "lose_weight", "maintain", "gain_muscle"

  StepsRequestModel({
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.goal,
  });

  Map<String, dynamic> toJson() {
    return {
      "height": height,
      "weight": weight,
      "age": age,
      "gender": gender,
      "goal": goal,
    };
  }
}
