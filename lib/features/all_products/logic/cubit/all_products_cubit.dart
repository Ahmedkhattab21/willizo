import 'package:bloc/bloc.dart';
import 'package:willizo/features/all_products/data/models/all_products_model_response.dart';
import 'package:willizo/features/all_products/data/repo/all_products_repo.dart';

part 'all_products_state.dart';

class AllProductsCubit extends Cubit<AllProductsState> {
  AllProductsCubit(this._allProductsRepo) : super(AllProductsInitial());
  final AllProductsRepo _allProductsRepo;

  Future<void> getAllProducts({int? page}) async {
    emit(AllProductsLoadingState());
    final result = await _allProductsRepo.getAllProducts(page: page);
    result.fold(
      (failure) => emit(AllProductsErrorState(message: failure.message)),
      (data) => emit(AllProductsLoadedState(allProductsData: data)),
    );
  }
}
