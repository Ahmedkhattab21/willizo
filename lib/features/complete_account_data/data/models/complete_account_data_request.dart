class StepsRequestModel {
  final int height; 
  final int weight; 
  final int age;
  final String gender; 
  final String goal; 

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
