import 'package:bloc/bloc.dart';
import 'package:willizo/features/product_details/data/models/add_product_to_cart_request_response.dart';
import 'package:willizo/features/product_details/data/models/add_product_to_wishlist_response.dart';
import 'package:willizo/features/product_details/data/models/create_review_request_model.dart';
import 'package:willizo/features/product_details/data/models/product_added_to_cart_response.dart';
import 'package:willizo/features/product_details/data/models/product_details_response_model.dart';
import 'package:willizo/features/product_details/data/models/product_reviews_response_model.dart';
import 'package:willizo/features/product_details/data/repo/product_details_repo.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._productDetailsRepo)
    : super(ProductDetailsInitial());

  final ProductDetailsRepo _productDetailsRepo;

  List<ReviewData> reviewsList = [];
  RatingSummary? ratingSummary;

  Future<void> addProductToWishlist(String productId) async {
    emit(AddProductToWishlistLoadingState());

    final result = await _productDetailsRepo.addProductToWishlist(productId);

    result.fold(
      (failure) =>
          emit(AddProductToWishlistErrorState(message: failure.message)),
      (response) => emit(AddProductToWishlistSuccessState(response: response)),
    );
  }

  Future<void> removeFromWishlist(String productId) async {
    emit(RemoveFromWishlistLoadingState());

    final result = await _productDetailsRepo.removeFromWishlist(productId);

    result.fold(
      (failure) => emit(RemoveFromWishlistErrorState(message: failure.message)),
      (success) => emit(RemoveFromWishlistSuccessState()),
    );
  }

  Future<void> addProductToCart(AddProductToCartRequest request) async {
    emit(AddToCartLoadingState());

    final result = await _productDetailsRepo.addProductToCart(request);

    result.fold(
      (failure) => emit(AddToCartErrorState(message: failure.message)),
      (response) => emit(AddToCartSuccessState(response: response)),
    );
  }

  Future<void> getProductDetails(String productId) async {
    emit(ProductDetailsLoadingState());

    final detailsResult = await _productDetailsRepo.getProductDetails(
      productId,
    );

    detailsResult.fold(
      (failure) => emit(ProductDetailsErrorState(message: failure.message)),
      (detailsData) {
        emit(ProductDetailsLoadedState(productDetails: detailsData));
        getProductReviews(productId);
      },
    );
  }

  Future<void> getProductReviews(String productId) async {
    final result = await _productDetailsRepo.getProductReviews(productId);

    result.fold(
      (failure) => null, // Handle error if necessary
      (reviewsData) {
        reviewsList = reviewsData.data;
        ratingSummary = reviewsData.ratingSummary;
        // Emit the same state to trigger UI update with the new list in cubit
        if (state is ProductDetailsLoadedState) {
          emit(
            ProductDetailsLoadedState(
              productDetails:
                  (state as ProductDetailsLoadedState).productDetails,
            ),
          );
        }
      },
    );
  }

  Future<String?> createReview(CreateReviewRequestModel request) async {
    emit(CreateReviewLoadingState());

    final result = await _productDetailsRepo.createReview(request);

    return result.fold(
      (failure) {
        emit(CreateReviewErrorState(message: failure.message));
        return failure.message;
      },
      (_) async {
        emit(CreateReviewSuccessState());
        await getProductReviews(request.productId);
        return null;
      },
    );
  }
}
