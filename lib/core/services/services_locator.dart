import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:get_it/get_it.dart';
import 'package:willizo/features/complete_account_data/step_18/data/repo/step18_repo.dart';
import 'package:willizo/features/complete_account_data/step_18/data/services/step18_services.dart';
import 'package:willizo/features/complete_account_data/step_19/data/repo/step19_repo.dart';
import 'package:willizo/features/complete_account_data/step_19/data/services/step19_services.dart';
import 'package:willizo/features/complete_account_data/step_20/data/repo/step20_repo.dart';
import 'package:willizo/features/complete_account_data/step_20/data/services/step20_services.dart';
import 'package:willizo/features/login_and_signup/data/repo/login_and_signup_repo.dart';
import 'package:willizo/features/login_and_signup/data/services/login_and_signup_service.dart';
import 'package:willizo/features/forget_password/data/repo/forget_password_repo.dart';
import 'package:willizo/features/forget_password/data/services/forget_password_service.dart';
import 'package:willizo/features/create_new_password/data/repo/reset_password_repo.dart';
import 'package:willizo/features/create_new_password/data/services/reset_password_service.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/data/services/complete_account_service.dart';
import 'package:willizo/features/account/data/repo/account_repo.dart';
import 'package:willizo/features/account/data/services/account_services.dart';
import 'package:willizo/features/all_products/data/repo/all_products_repo.dart';
import 'package:willizo/features/all_products/data/services/all_products_service.dart';
import 'package:willizo/features/product_details/data/repo/product_details_repo.dart';
import 'package:willizo/features/product_details/data/services/product_details_service.dart';
import 'package:willizo/features/shop/data/repo/shop_repo.dart';
import 'package:willizo/features/shop/data/services/shop_service.dart';
import 'package:willizo/features/wishlist/data/repos/wishlist_repo.dart';
import 'package:willizo/features/wishlist/data/services/wishlist_service.dart';
import 'package:willizo/features/cart/data/repos/cart_repo.dart';
import 'package:willizo/features/cart/data/services/cart_service.dart';
import 'package:willizo/features/checkout/data/repos/checkout_repo.dart';
import 'package:willizo/features/checkout/data/services/checkout_services.dart';
import 'package:willizo/features/my_order/data/repos/orders_repo.dart';
import 'package:willizo/features/my_order/data/services/orders_service.dart';
import 'package:willizo/features/shop/logic/cubit/badge_cubit.dart';
import 'package:willizo/features/community/data/services/community_services.dart';
import 'package:willizo/features/community/data/repo/community_repo.dart';
import 'package:willizo/features/home/data/repo/home_repo.dart';
import 'package:willizo/features/home/data/services/home_services.dart';
import 'package:willizo/features/workout/data/repo/body_parts_repo.dart';
import 'package:willizo/features/workout/data/repo/recipes_repo.dart';
import 'package:willizo/features/workout/data/services/body_parts_services.dart';
import 'package:willizo/features/workout/data/services/recipes_services.dart';

import '../api/api_consumer.dart';
import '../api/app_interceptor.dart';
import '../api/http_consumer.dart';

final getIt = GetIt.instance;

class ServicesLocator {
  static Future<void> init() async {
    getIt.registerLazySingleton<LoginAndSignupRepo>(
      () => LoginAndSignupRepo(getIt()),
    );
    getIt.registerLazySingleton<LoginAndSignupService>(
      () => LoginAndSignupService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<ForgetPasswordRepo>(
      () => ForgetPasswordRepo(getIt()),
    );
    getIt.registerLazySingleton<ForgetPasswordService>(
      () => ForgetPasswordService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<ResetPasswordRepo>(
      () => ResetPasswordRepo(getIt()),
    );
    getIt.registerLazySingleton<ResetPasswordService>(
      () => ResetPasswordService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<CompleteAccountRepo>(
      () => CompleteAccountRepo(completeAccountService: getIt()),
    );
    getIt.registerLazySingleton<CompleteAccountService>(
      () => CompleteAccountService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<AccountRepo>(() => AccountRepo(getIt()));
    getIt.registerLazySingleton<AccountService>(
      () => AccountService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<ShopRepo>(() => ShopRepo(getIt()));
    getIt.registerLazySingleton<ShopService>(
      () => ShopService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<AllProductsRepo>(
      () => AllProductsRepo(getIt()),
    );
    getIt.registerLazySingleton<AllProductsService>(
      () => AllProductsService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<ProductDetailsRepo>(
      () => ProductDetailsRepo(getIt()),
    );
    getIt.registerLazySingleton<ProductDetailsService>(
      () => ProductDetailsService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<WishlistRepo>(() => WishlistRepo(getIt()));
    getIt.registerLazySingleton<WishlistService>(
      () => WishlistService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<CartRepo>(() => CartRepo(getIt()));
    getIt.registerLazySingleton<CartService>(
      () => CartService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<CheckoutRepo>(() => CheckoutRepo(getIt()));
    getIt.registerLazySingleton<CheckoutService>(
      () => CheckoutService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<OrdersRepo>(() => OrdersRepo(getIt()));
    getIt.registerLazySingleton<OrdersService>(
      () => OrdersService(apiConsumer: getIt()),
    );

    // Badge Cubit (singleton for cart & wishlist badge counts)
    getIt.registerLazySingleton<BadgeCubit>(
      () => BadgeCubit(cartRepo: getIt(), wishlistRepo: getIt()),
    );

    ///core

    getIt.registerLazySingleton<AppInterceptor>(() => AppInterceptor());

    getIt.registerLazySingleton<ApiConsumer>(() => HttpConsumer(getIt()));
    getIt.registerLazySingleton(() => http.Client());

    ///shared secure
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    getIt.registerLazySingleton(() => secureStorage);

    // Community / Leaderboard
    getIt.registerLazySingleton<CommunityServices>(
      () => CommunityServices(getIt()),
    );
    getIt.registerLazySingleton<CommunityRepo>(
      () => CommunityRepo(communityServices: getIt()),
    );

    // Home
    getIt.registerLazySingleton<HomeServices>(() => HomeServices(getIt()));
    getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));

    // Workout Recipes
    getIt.registerLazySingleton<RecipesServices>(
      () => RecipesServices(getIt()),
    );
    getIt.registerLazySingleton<RecipesRepo>(() => RecipesRepo(getIt()));

    // Workout Body Parts
    getIt.registerLazySingleton<BodyPartsServices>(
      () => BodyPartsServices(getIt()),
    );
    getIt.registerLazySingleton<BodyPartsRepo>(() => BodyPartsRepo(getIt()));

    getIt.registerLazySingleton<Step18Services>(() => Step18Services(getIt()));
    getIt.registerLazySingleton<Step18Repo>(() => Step18Repo(getIt()));
    getIt.registerLazySingleton<Step19Services>(() => Step19Services(getIt()));
    getIt.registerLazySingleton<Step19Repo>(() => Step19Repo(getIt()));
    getIt.registerLazySingleton<Step20Services>(() => Step20Services(getIt()));
    getIt.registerLazySingleton<Step20Repo>(() => Step20Repo(getIt()));
  }
}
