import 'package:bloc/bloc.dart';
import 'package:willizo/features/shop/data/models/categories_model_response.dart';
import 'package:willizo/features/shop/data/repo/shop_repo.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._shopRepo) : super(CategoriesInitial());
  final ShopRepo _shopRepo;

  Future<void> getCategories() async {
    emit(CategoriesLoadingState());
    final result = await _shopRepo.getCategories();
    result.fold(
      (failure) => emit(CategoriesErrorState(message: failure.message)),
      (data) => emit(CategoriesLoadedState(categoriesData: data)),
    );
  }
}
