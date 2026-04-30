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
                  (e) => RecipeModel.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
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
  final String rating;
  final bool isFeatured;
  final bool isPopular;
  final bool isActive;
  final List<RecipeIngredientModel> ingredients;

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
    required this.rating,
    required this.isFeatured,
    required this.isPopular,
    required this.isActive,
    required this.ingredients,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final ingredientsRaw = json['ingredients'];
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
      rating: _toString(json['rating']),
      isFeatured: _toBool(json['is_featured']),
      isPopular: _toBool(json['is_popular']),
      isActive: _toBool(json['is_active'], fallback: true),
      ingredients: ingredientsRaw is List
          ? ingredientsRaw
                .map(
                  (e) => RecipeIngredientModel.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList()
          : const [],
    );
  }

  static List<RecipeModel> listFromJson(dynamic value) {
    if (value is! List) return const [];
    return value
        .map(
          (e) => RecipeModel.fromJson(
            (e as Map).cast<String, dynamic>(),
          ),
        )
        .toList();
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
