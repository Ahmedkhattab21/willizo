// import 'package:smart_app/core/services/cache_helper.dart';
// import 'package:smart_app/core/services/firebase_notification_service.dart';
// import 'package:smart_app/core/utils/constant_keys.dart';
// import 'package:smart_app/features/user/login/data/models/login_request_model.dart';
// import 'package:smart_app/features/user/login/data/repo/login_repo.dart';
// import 'package:smart_app/features/user/login/logic/login_state.dart';
// import 'package:flutter/cupertino.dart';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class LoginCubit extends Cubit<LoginState> {
//   final LoginRepo _loginRepo;
//
//   LoginCubit(this._loginRepo) : super(InitialState());
//
//   GlobalKey<FormState> loginKey = GlobalKey<FormState>();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   bool isPasswordVisible = false;
//
//   changePasswordState() {
//     isPasswordVisible = !isPasswordVisible;
//     emit(IsPasswordVisibleState());
//   }
//
//   bool isClient = true;
//
//   changeIsClientState(bool value) {
//     isClient = value;
//     emit(IsClientChangeStateState());
//   }
//
//   login() async {
//     emit(OnLoginLoadingState());
//     _loginRepo
//         .login(
//           isClient,
//           LoginRequestModel(
//             email: emailController.text,
//             password: passwordController.text,
//             fcm: await FirebaseNotificationService.getDeviceToken(),
//           ),
//         )
//         .then((value) {
//           value.fold(
//             (l) {
//               emit(OnLoginErrorState());
//             },
//             (r) async {
//               await cashUserData(
//                 r.token,
//                 r.loginData.id.toString(),
//                 r.isClient,
//               );
//               emit(OnLoginSuccessState(isClient: r.isClient));
//             },
//           );
//         })
//         .catchError((error) {
//           emit(OnLoginCatchErrorState());
//         });
//   }
//
//   Future<void> cashUserData(String token, String id, bool isClient) async {
//     await CacheHelper.setSecuredString(ConstantKeys.saveIdToShared, id);
//     await CacheHelper.setSecuredString(ConstantKeys.saveTokenToShared, token);
//     // await CacheHelper.setSecuredString(ConstantKeys.saveNameToShared, name);
//     await CacheHelper.setSecuredString(
//       ConstantKeys.saveUserTypeToShared,
//       isClient ? 'client' : 'sponsor',
//     );
//   }
//
//   static LoginCubit get(context) => BlocProvider.of(context);
// }
