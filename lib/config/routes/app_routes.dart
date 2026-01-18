import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/features/billing/ui/billing_screen.dart';
import 'package:willizo/features/cart/ui/cart_screen.dart';
import 'package:willizo/features/cart/logic/cubit/cart_cubit.dart';
import 'package:willizo/features/checkout/ui/checkout_screen.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_18/data/repo/step18_repo.dart';
import 'package:willizo/features/complete_account_data/step_19/data/repo/step19_repo.dart';
import 'package:willizo/features/complete_account_data/step_20/data/repo/step20_repo.dart';
import 'package:willizo/features/cart/data/models/cart_response_model.dart';
import 'package:willizo/features/button_nav_bar/logic/cubit/button_nav_bar_cubit.dart';
import 'package:willizo/features/button_nav_bar/ui/button_nav_bar.dart';
import 'package:willizo/features/complete_account_data/step_1/logic/step_1_cubit.dart';
import 'package:willizo/features/complete_account_data/step_1/ui/step_1_screen.dart';
import 'package:willizo/features/complete_account_data/step_10/logic/step_10_cubit.dart';
import 'package:willizo/features/complete_account_data/step_10/ui/step_10_screen.dart';
import 'package:willizo/features/complete_account_data/step_11/logic/step_11_cubit.dart';
import 'package:willizo/features/complete_account_data/step_11/ui/step_11_screen.dart';
import 'package:willizo/features/complete_account_data/step_12/logic/step_12_cubit.dart';
import 'package:willizo/features/complete_account_data/step_12/ui/step_12_screen.dart';
import 'package:willizo/features/complete_account_data/step_13/logic/step_13_cubit.dart';
import 'package:willizo/features/complete_account_data/step_13/ui/step_13_screen.dart';
import 'package:willizo/features/complete_account_data/step_14/logic/step_14_cubit.dart';
import 'package:willizo/features/complete_account_data/step_14/ui/step_14_screen.dart';
import 'package:willizo/features/complete_account_data/step_15/logic/step_15_cubit.dart';
import 'package:willizo/features/complete_account_data/step_15/ui/step_15_screen.dart';
import 'package:willizo/features/complete_account_data/step_16/logic/step_16_cubit.dart';
import 'package:willizo/features/complete_account_data/step_16/ui/step_16_screen.dart';
import 'package:willizo/features/complete_account_data/step_17/logic/step_17_cubit.dart';
import 'package:willizo/features/complete_account_data/step_17/ui/step_17_screen.dart';
import 'package:willizo/features/complete_account_data/step_18/logic/step_18_cubit.dart';
import 'package:willizo/features/complete_account_data/step_18/ui/step_18_screen.dart';
import 'package:willizo/features/complete_account_data/step_19/logic/step_19_cubit.dart';
import 'package:willizo/features/complete_account_data/step_19/ui/step_19_screen.dart';
import 'package:willizo/features/complete_account_data/step_2/logic/step_2_cubit.dart';
import 'package:willizo/features/complete_account_data/step_2/ui/step_2_screen.dart';
import 'package:willizo/features/complete_account_data/step_20/logic/step_20_cubit.dart';
import 'package:willizo/features/complete_account_data/step_20/ui/step_20_screen.dart';
import 'package:willizo/features/complete_account_data/step_21/logic/step_21_cubit.dart';
import 'package:willizo/features/complete_account_data/step_21/ui/step_21_screen.dart';
import 'package:willizo/features/complete_account_data/step_3/logic/step_3_cubit.dart';
import 'package:willizo/features/complete_account_data/step_3/ui/step_3_screen.dart';
import 'package:willizo/features/complete_account_data/step_4/logic/step_4_cubit.dart';
import 'package:willizo/features/complete_account_data/step_4/ui/step_4_screen.dart';
import 'package:willizo/features/complete_account_data/step_5/logic/step_5_cubit.dart';
import 'package:willizo/features/complete_account_data/step_5/ui/step_5_screen.dart';
import 'package:willizo/features/complete_account_data/step_6/logic/step_6_cubit.dart';
import 'package:willizo/features/complete_account_data/step_6/ui/step_6_screen.dart';
import 'package:willizo/features/complete_account_data/step_7/logic/step_7_cubit.dart';
import 'package:willizo/features/complete_account_data/step_7/ui/step_7_screen.dart';
import 'package:willizo/features/complete_account_data/step_8/logic/step_8_cubit.dart';
import 'package:willizo/features/complete_account_data/step_8/ui/step_8_screen.dart';
import 'package:willizo/features/complete_account_data/step_9/logic/step_9_cubit.dart';
import 'package:willizo/features/complete_account_data/step_9/ui/step_9_screen.dart';
import 'package:willizo/features/create_new_password/data/repo/reset_password_repo.dart';
import 'package:willizo/features/create_new_password/logic/create_new_password_cubit.dart';
import 'package:willizo/features/create_new_password/ui/create_new_password_screen.dart';
import 'package:willizo/features/create_new_password_done/ui/create_new_password_done_screen.dart';
import 'package:willizo/features/forget_password/logic/forget_password_cubit.dart';
import 'package:willizo/features/forget_password/ui/forget_password_screen.dart';
import 'package:willizo/features/forget_password_code/logic/forget_password_code_cubit.dart';
import 'package:willizo/features/forget_password_code/ui/forget_password_code_screen.dart';
import 'package:willizo/features/forget_password_done/logic/forget_password_done_cubit.dart';
import 'package:willizo/features/forget_password_done/ui/forget_password_done_screen.dart';
import 'package:willizo/features/my_favourite/ui/my_favourtie_screen.dart';
import 'package:willizo/features/my_order/ui/my_order_screen.dart';
import 'package:willizo/features/notificatoin/ui/notification_screen.dart';
import 'package:willizo/features/onboarding/logic/onboarding_cubit.dart';
import 'package:willizo/features/onboarding/ui/onboarding_screen.dart';
import 'package:willizo/features/login_and_signup/logic/login_and_signup_cubit.dart';
import 'package:willizo/features/login_and_signup/ui/sign_in_screen.dart';
import 'package:willizo/features/order_details/ui/order_details_screen.dart';
import 'package:willizo/features/plan_details/ui/plan_details_screen.dart';
import 'package:willizo/features/product_details/logic/cubit/product_details_cubit.dart';
import 'package:willizo/features/product_details/ui/product_details_screen.dart';
import 'package:willizo/features/splash/ui/splash_video_screen.dart';
import 'package:willizo/features/subscrip/ui/subscribe_screen.dart';
import 'package:willizo/features/top_friends/ui/top_friends_screen.dart';
import 'package:willizo/features/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:willizo/features/wishlist/ui/wishlist_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;
    switch (settings.name) {
      case Routes.splashVideoScreen:
        return MaterialPageRoute(builder: (_) => SplashVideoScreen());

      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => OnboardingCubit(),
            child: OnBoardingScreen(),
          ),
        );

      case Routes.signInScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginAndSignup(getIt()),
            child: SignInScreen(),
          ),
        );
      case Routes.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ForgetPasswordCubit(getIt()),
            child: ForgetPasswordScreen(),
          ),
        );
      case Routes.forgetPasswordCodeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ForgetPasswordCodeCubit(),
            child: ForgetPasswordCodeScreen(),
          ),
        );
      case Routes.forgetPasswordDoneScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ForgetPasswordDoneCubit(),
            child: ForgetPasswordDoneScreen(),
          ),
        );
      case Routes.createNewPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                CreateNewPasswordCubit(getIt<ResetPasswordRepo>()),
            child: CreateNewPasswordScreen(
              email: args != null ? args['email'] : null,
            ),
          ),
        );
      case Routes.createNewPasswordDoneScreen:
        return MaterialPageRoute(builder: (_) => CreateNewPasswordDoneScreen());

      ///steps
      case Routes.step1Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step1Cubit(getIt<CompleteAccountRepo>()),
            child: Step1Screen(),
          ),
        );
      case Routes.step2Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step2Cubit(getIt<CompleteAccountRepo>()),
            child: Step2Screen(),
          ),
        );
      case Routes.step3Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step3Cubit(getIt<CompleteAccountRepo>()),
            child: Step3Screen(),
          ),
        );
      case Routes.step4Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step4Cubit(getIt<CompleteAccountRepo>()),
            child: Step4Screen(),
          ),
        );
      case Routes.step5Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step5Cubit(getIt<CompleteAccountRepo>()),
            child: Step5Screen(),
          ),
        );
      case Routes.step6Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step6Cubit(getIt<CompleteAccountRepo>()),
            child: Step6Screen(),
          ),
        );

      case Routes.step7Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step7Cubit(getIt<CompleteAccountRepo>()),
            child: Step7Screen(),
          ),
        );

      case Routes.step8Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step8Cubit(getIt<CompleteAccountRepo>()),
            child: Step8Screen(),
          ),
        );
      case Routes.step9Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step9Cubit(getIt<CompleteAccountRepo>()),
            child: Step9Screen(),
          ),
        );
      case Routes.step10Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step10Cubit(getIt<CompleteAccountRepo>()),
            child: Step10Screen(),
          ),
        );
      case Routes.step11Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step11Cubit(getIt<CompleteAccountRepo>()),
            child: Step11Screen(),
          ),
        );
      case Routes.step12Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step12Cubit(getIt<CompleteAccountRepo>()),
            child: Step12Screen(),
          ),
        );
      case Routes.step13Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step13Cubit(getIt<CompleteAccountRepo>()),
            child: Step13Screen(),
          ),
        );
      case Routes.step14Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step14Cubit(getIt<CompleteAccountRepo>()),
            child: Step14Screen(),
          ),
        );
      case Routes.step15Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step15Cubit(getIt<CompleteAccountRepo>()),
            child: Step15Screen(),
          ),
        );
      case Routes.step16Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step16Cubit(getIt<CompleteAccountRepo>()),
            child: Step16Screen(),
          ),
        );
      case Routes.step17Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step17Cubit(getIt<CompleteAccountRepo>()),
            child: Step17Screen(),
          ),
        );
      case Routes.step18Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                Step18Cubit(getIt<Step18Repo>(), getIt<CompleteAccountRepo>()),
            child: Step18Screen(),
          ),
        );
      case Routes.step19Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                Step19Cubit(getIt<Step19Repo>(), getIt<CompleteAccountRepo>()),
            child: Step19Screen(),
          ),
        );
      case Routes.step20Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                Step20Cubit(getIt<Step20Repo>(), getIt<CompleteAccountRepo>()),
            child: Step20Screen(),
          ),
        );

      case Routes.step21Screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => Step21Cubit(getIt<CompleteAccountRepo>()),
            child: Step21Screen(),
          ),
        );

      case Routes.buttonNavBarWidget:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ButtonNavBarCubit(),
            child: const ButtonNavBarWidget(),
          ),
        );

      case Routes.notificationScreen:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case Routes.topFriendsScreen:
        return MaterialPageRoute(builder: (_) => const TopFriendsScreen());
      // ///user routes
      // case Routes.loginScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (context) => LoginCubit(getIt()),
      //       child: LoginScreen(),
      //     ),
      //   );
      case Routes.productDetailsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProductDetailsCubit(getIt())
              ..getProductDetails(args['productId']),
            child: ProductDetailsScreen(
              productId: args != null ? args['productId'] : "",
            ),
          ),
        );

      case Routes.cartScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CartCubit(getIt())..getCart(),
            child: const CartScreen(),
          ),
        );
      case Routes.myFavouriteScreen:
        return MaterialPageRoute(builder: (_) => const MyFavouriteScreen());
      // case Routes.chatScreen:
      //   return MaterialPageRoute(builder: (_) => AllChatsScreen());
      case Routes.myOrderScreen:
        return MaterialPageRoute(builder: (_) => const MyOrderScreen());
      case Routes.myOrderDetailsScreen:
        return MaterialPageRoute(builder: (_) => const MyOrderDetailsScreen());
      case Routes.subscribeScreen:
        return MaterialPageRoute(builder: (_) => const SubscribeScreen());
      case Routes.billingScreen:
        return MaterialPageRoute(builder: (_) => const BillingScreen());
      case Routes.planDetailsScreen:
        return MaterialPageRoute(builder: (_) => const PlanDetailsScreen());
      case Routes.wishlistScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => WishlistCubit(getIt())..getWishlist(),
            child: const WishlistScreen(),
          ),
        );
      case Routes.checkoutScreen:
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            cartItems: args is Map && args['cartItems'] != null
                ? (args['cartItems'] as List).cast<CartItem>()
                : [],
          ),
        );
      default:
        return null;
    }
  }
}
