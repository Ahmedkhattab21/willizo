class RecipesResponseModel {
  final int currentPage;
  final List<RecipeModel> data;
  final int lastPage;
  final int total;

  const RecipesResponseModel({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.total,
  });

  factory RecipesResponseModel.fromJson(Map<String, dynamic> json) {
    final recipesRaw = json['data'];
    return RecipesResponseModel(
      currentPage: _toInt(json['current_page']),
      data: recipesRaw is List
          ? recipesRaw
                .map(
                  (e) =>
                      RecipeModel.fromJson((e as Map).cast<String, dynamic>()),
                )
                .toList()
          : const [],
      lastPage: _toInt(json['last_page']),
      total: _toInt(json['total']),
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
  final int totalTime;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;
  final String rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isPopular;
  final bool isActive;
  final bool isFavorited;
  final List<RecipeIngredientModel> ingredients;
  final List<RecipeInstructionModel> instructions;
  final List<String> proTips;
  final List<RecipeBestTimeModel> bestTimes;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.totalTime,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.rating,
    required this.reviewCount,
    required this.isFeatured,
    required this.isPopular,
    required this.isActive,
    required this.isFavorited,
    required this.ingredients,
    required this.instructions,
    required this.proTips,
    required this.bestTimes,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final ingredientsRaw = json['ingredients'];
    final instructionsRaw = json['instructions'];
    final tipsRaw = json['pro_tips'] ?? json['tips'];
    final bestTimesRaw =
        json['best_times_to_eat'] ??
        json['best_times'] ??
        json['best_time_to_eat'];
    return RecipeModel(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      slug: _toString(json['slug']),
      description: _toString(json['description']),
      imageUrl: _toString(json['image_url']),
      category: _toString(json['category']),
      totalTime: _toInt(json['total_time']),
      calories: _toInt(json['calories']),
      protein: _toInt(json['protein']),
      carbs: _toInt(json['carbs']),
      fat: _toInt(json['fat']),
      fiber: _toInt(json['fiber']),
      prepTime: _toInt(json['prep_time']),
      cookTime: _toInt(json['cook_time']),
      servings: _toInt(json['servings']),
      difficulty: _toString(json['difficulty']),
      rating: _toString(json['rating']).isNotEmpty
          ? _toString(json['rating'])
          : _toString(json['average_rating']),
      reviewCount: _toInt(
        json['review_count'] ?? json['reviews_count'] ?? json['rating_count'],
      ),
      isFeatured: _toBool(json['is_featured']),
      isPopular: _toBool(json['is_popular']),
      isActive: _toBool(json['is_active'], fallback: true),
      isFavorited: _toBool(json['is_favorited'] ?? json['is_favorite']),
      ingredients: ingredientsRaw is List
          ? ingredientsRaw
                .map(
                  (e) => RecipeIngredientModel.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList()
          : const [],
      instructions: instructionsRaw is List
          ? instructionsRaw
                .asMap()
                .entries
                .map(
                  (entry) => RecipeInstructionModel.fromDynamic(
                    entry.value,
                    entry.key,
                  ),
                )
                .toList()
          : const [],
      proTips: _toStringList(tipsRaw),
      bestTimes: bestTimesRaw is List
          ? bestTimesRaw.map((e) => RecipeBestTimeModel.fromDynamic(e)).toList()
          : _toStringList(bestTimesRaw)
                .map((e) => RecipeBestTimeModel(label: e, status: 'Good'))
                .toList(),
    );
  }

  static List<RecipeModel> listFromJson(dynamic value) {
    final list = value is Map<String, dynamic> ? value['data'] : value;
    if (list is! List) return const [];
    return list
        .map((e) => RecipeModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  RecipeModel copyWith({bool? isFavorited}) {
    return RecipeModel(
      id: id,
      name: name,
      slug: slug,
      description: description,
      imageUrl: imageUrl,
      category: category,
      totalTime: totalTime,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
      prepTime: prepTime,
      cookTime: cookTime,
      servings: servings,
      difficulty: difficulty,
      rating: rating,
      reviewCount: reviewCount,
      isFeatured: isFeatured,
      isPopular: isPopular,
      isActive: isActive,
      isFavorited: isFavorited ?? this.isFavorited,
      ingredients: ingredients,
      instructions: instructions,
      proTips: proTips,
      bestTimes: bestTimes,
    );
  }
}

class RecipeInstructionModel {
  final int step;
  final String title;
  final String description;

  const RecipeInstructionModel({
    required this.step,
    required this.title,
    required this.description,
  });

  factory RecipeInstructionModel.fromJson(Map<String, dynamic> json) {
    return RecipeInstructionModel(
      step: _toInt(json['step'] ?? json['step_number'] ?? json['order']),
      title: _toString(json['title']),
      description: _toString(json['description'] ?? json['instruction']),
    );
  }

  factory RecipeInstructionModel.fromDynamic(dynamic value, int index) {
    if (value is Map) {
      return RecipeInstructionModel.fromJson(value.cast<String, dynamic>());
    }
    return RecipeInstructionModel(
      step: index + 1,
      title: 'Step ${index + 1}',
      description: _toString(value),
    );
  }
}

class RecipeBestTimeModel {
  final String label;
  final String status;

  const RecipeBestTimeModel({required this.label, required this.status});

  factory RecipeBestTimeModel.fromJson(Map<String, dynamic> json) {
    return RecipeBestTimeModel(
      label: _toString(json['label'] ?? json['meal_type'] ?? json['time']),
      status: _toString(json['status'] ?? json['recommendation']),
    );
  }

  factory RecipeBestTimeModel.fromDynamic(dynamic value) {
    if (value is Map) {
      return RecipeBestTimeModel.fromJson(value.cast<String, dynamic>());
    }
    return RecipeBestTimeModel(label: _toString(value), status: 'Good');
  }
}

class RecipeIngredientModel {
  final int id;
  final int recipeId;
  final String name;
  final String amount;
  final int order;

  const RecipeIngredientModel({
    required this.id,
    required this.recipeId,
    required this.name,
    required this.amount,
    required this.order,
  });

  factory RecipeIngredientModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientModel(
      id: _toInt(json['id']),
      recipeId: _toInt(json['recipe_id']),
      name: _toString(json['name']),
      amount: _toString(json['amount']),
      order: _toInt(json['order']),
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is num) return value.toInt();
  return 0;
}

String _toString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

bool _toBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final normalized = value.toLowerCase().trim();
    return normalized == '1' || normalized == 'true';
  }
  return fallback;
}

List<String> _toStringList(dynamic value) {
  if (value is List) return value.map((e) => _toString(e)).toList();
  final text = _toString(value);
  if (text.isEmpty) return const [];
  return text
      .split(RegExp(r'[.,]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}
