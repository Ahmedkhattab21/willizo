import 'package:bloc/bloc.dart';
import 'package:willizo/features/shop/data/models/shop_model_response.dart';
import 'package:willizo/features/shop/data/repo/shop_repo.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit(this._shopRepo) : super(ShopInitial());
  final ShopRepo _shopRepo;

  Future<void> getFeaturedProducts() async {
    emit(FetchShopLoadingState());
    final result = await _shopRepo.getFeaturedProducts();
    result.fold(
      (failure) => emit(FetchShopErrorState(message: failure.message)),
      (data) => emit(FetchShopLoadedState(shopData: data)),
    );
  }
}
