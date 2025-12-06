import 'package:willizo/features/shop/data/models/shop_model_response.dart';

class CategoriesResponseModel {
  final List<Category> data;

  CategoriesResponseModel({required this.data});

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => Category.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
