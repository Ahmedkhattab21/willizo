class MyMealPlansResponseModel {
  final String date;
  final List<ScheduledMealModel> meals;

  MyMealPlansResponseModel({
    required this.date,
    required this.meals,
  });

  factory MyMealPlansResponseModel.fromJson(Map<String, dynamic> json) {
    return MyMealPlansResponseModel(
      date: json['date']?.toString() ?? '',
      meals: (json['meals'] as List<dynamic>?)
              ?.map((e) => ScheduledMealModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ScheduledMealModel {
  final int id;
  final String mealType;
  final bool isCompleted;
  final RecipeModel recipe;

  ScheduledMealModel({
    required this.id,
    required this.mealType,
    required this.isCompleted,
    required this.recipe,
  });

  factory ScheduledMealModel.fromJson(Map<String, dynamic> json) {
    final recipeJson = json['recipe'];
    return ScheduledMealModel(
      id: _asInt(json['id']),
      mealType: json['meal_type']?.toString() ?? '',
      isCompleted: json['is_completed'] == true,
      recipe: recipeJson is Map<String, dynamic>
          ? RecipeModel.fromJson(recipeJson)
          : RecipeModel.empty(),
    );
  }
}

class RecipeModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String imageUrl;
  final String category;
  final String difficulty;
  final int? prepTime;
  final int? cookTime;
  final int? totalTime;
  final int? servings;
  final int? calories;
  final int? protein;
  final int? carbs;
  final int? fat;

  RecipeModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.difficulty,
    this.prepTime,
    this.cookTime,
    this.totalTime,
    this.servings,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
  });

  factory RecipeModel.empty() {
    return RecipeModel(
      id: 0,
      name: '',
      slug: '',
      description: '',
      imageUrl: '',
      category: '',
      difficulty: '',
    );
  }

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      difficulty: json['difficulty']?.toString() ?? '',
      prepTime: _asNullableInt(json['prep_time']),
      cookTime: _asNullableInt(json['cook_time']),
      totalTime: _asNullableInt(json['total_time']),
      servings: _asNullableInt(json['servings']),
      calories: _asNullableInt(json['calories']),
      protein: _asNullableInt(json['protein']),
      carbs: _asNullableInt(json['carbs']),
      fat: _asNullableInt(json['fat']),
    );
  }
}

int _asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

int? _asNullableInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString());
}
