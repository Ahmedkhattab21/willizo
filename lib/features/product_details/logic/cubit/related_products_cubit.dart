import 'package:bloc/bloc.dart';
import 'package:willizo/features/product_details/data/repo/product_details_repo.dart';
import 'package:willizo/features/shop/data/models/shop_model_response.dart';

part 'related_products_state.dart';

class RelatedProductsCubit extends Cubit<RelatedProductsState> {
  RelatedProductsCubit(this._productDetailsRepo)
    : super(RelatedProductsInitial());
  final ProductDetailsRepo _productDetailsRepo;

  Future<void> getRelatedProducts(String productSlug) async {
    emit(RelatedProductsLoadingState());
    final result = await _productDetailsRepo.getRelatedProducts(productSlug);
    result.fold(
      (failure) => emit(RelatedProductsErrorState(message: failure.message)),
      (data) => emit(RelatedProductsLoadedState(relatedProductsData: data)),
    );
  }
}
