class Routes {
  static const splashVideoScreen = "/SplashVideoScreen";
  static const onBoardingScreen = "/OnBoardingScreen";
  static const signInScreen = "/SignInScreen";
  static const forgetPasswordScreen = "/ForgetPasswordScreen";
  static const forgetPasswordCodeScreen = "/ForgetPasswordCodeScreen";
  static const forgetPasswordDoneScreen = "/ForgetPasswordDoneScreen";
  static const createNewPasswordScreen = "/CreateNewPasswordScreen";
  static const createNewPasswordDoneScreen = "/CreateNewPasswordDoneScreen";
  static const step1Screen = "/Step1Screen";
  static const step2Screen = "/Step2Screen";
  static const step3Screen = "/Step3Screen";
  static const step4Screen = "/Step4Screen";
  static const step5Screen = "/Step5Screen";
  static const step6Screen = "/Step6Screen";
  static const step7Screen = "/Step7Screen";
  static const step8Screen = "/Step8Screen";
  static const step9Screen = "/Step9Screen";
  static const step10Screen = "/Step10Screen";
  static const step11Screen = "/Step11Screen";
  static const step12Screen = "/Step12Screen";
  static const step13Screen = "/Step13Screen";

  static const step14Screen = "/Step14Screen";
  static const step15Screen = "/Step15Screen";
  static const step16Screen = "/Step16Screen";
  static const step17Screen = "/Step17Screen";
  static const step18Screen = "/Step18Screen";
  static const step19Screen = "/Step19Screen";
  static const step20Screen = "/Step20Screen";
  static const step21Screen = "/Step21Screen";
  static const buttonNavBarWidget = "/ButtonNavBarWidget";
  static const notificationScreen = "/NotificationScreen";
  static const topFriendsScreen = "/TopFriendsScreen";
  static const productDetailsScreen = "/ProductDetailsScreen";
  static const cartScreen = "/CartScreen";
  static const myFavouriteScreen = "/MyFavouriteScreen";
  static const myOrderScreen = "/MyOrderScreen";
  static const myOrderDetailsScreen = "/MyOrderDetailsScreen";
  static const subscribeScreen = "/SubscribeScreen";
  static const billingScreen = "/BillingScreen";
  static const planDetailsScreen = "/PlanDetailsScreen";

  /// Maps step number to corresponding route
  static String getStepRoute(int stepNumber) {
    switch (stepNumber) {
      case 1:
        return step1Screen;
      case 2:
        return step2Screen;
      case 3:
        return step3Screen;
      case 4:
        return step4Screen;
      case 5:
        return step5Screen;
      case 6:
        return step6Screen;
      case 7:
        return step7Screen;
      case 8:
        return step8Screen;
      case 9:
        return step9Screen;
      case 10:
        return step10Screen;
      case 11:
        return step11Screen;
      case 12:
        return step12Screen;
      case 13:
        return step13Screen;
      case 14:
        return step14Screen;
      case 15:
        return step15Screen;
      case 16:
        return step16Screen;
      case 17:
        return step17Screen;
      case 18:
        return step18Screen;
      case 19:
        return step19Screen;
      case 20:
        return step20Screen;
      case 21:
        return step21Screen;
      default:
        return step1Screen; // Default to step 1 if invalid step number
    }
  }
}
