import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:willizo/features/all_products/data/models/all_products_model_response.dart';
import 'package:willizo/features/shop/data/repo/shop_repo.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  CategoryProductsCubit(this._shopRepo) : super(CategoryProductsInitial());
  final ShopRepo _shopRepo;

  Future<void> getCategoryProducts(String categorySlug) async {
    debugPrint(
      '🟡 [CategoryProductsCubit] Fetching products for category slug: $categorySlug',
    );
    emit(CategoryProductsLoadingState());
    final result = await _shopRepo.getCategoryProducts(categorySlug);
    result.fold(
      (failure) {
        debugPrint(
          '🔴 [CategoryProductsCubit] Error fetching products for slug $categorySlug: ${failure.message}',
        );
        emit(CategoryProductsErrorState(message: failure.message));
      },
      (data) {
        debugPrint(
          '🟢 [CategoryProductsCubit] Successfully loaded ${data.data.length} products for category slug: $categorySlug',
        );
        emit(CategoryProductsLoadedState(categoryProductsData: data));
      },
    );
  }
}
