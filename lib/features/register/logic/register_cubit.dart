// import 'package:smart_app/core/services/cache_helper.dart';
// import 'package:smart_app/core/utils/app_colors_white_theme.dart';
// import 'package:smart_app/core/utils/constant_keys.dart';
// import 'package:smart_app/features/user/login/data/models/login_request_model.dart';
// import 'package:smart_app/features/user/login/data/repo/login_repo.dart';
// import 'package:smart_app/features/user/register/data/models/register_request_model.dart';
// import 'package:smart_app/features/user/register/data/repo/register_repo.dart';
// import 'package:smart_app/features/user/register/logic/register_state.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class RegisterCubit extends Cubit<RegisterState> {
//   final RegisterRepo _registerRepo;
//
//   RegisterCubit(this._registerRepo) : super(InitialState());
//
//   GlobalKey<FormState> registerKey = GlobalKey<FormState>();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController jobController = TextEditingController();
//   TextEditingController countryCodeController = TextEditingController(
//     text: "+20",
//   );
//   TextEditingController passwordController = TextEditingController();
//   bool isPasswordVisible = false;
//
//   changePasswordState() {
//     isPasswordVisible = !isPasswordVisible;
//     emit(IsPasswordVisibleState());
//   }
//
//   register() {
//     emit(OnRegisterLoadingState());
//     _registerRepo
//         .register(
//           RegisterRequestModel(
//             name: nameController.text,
//             email: emailController.text,
//             phone: phoneController.text,
//             countryCode: countryCodeController.text,
//             job: jobController.text,
//             password: passwordController.text,
//           ),
//         )
//         .then((value) {
//           value.fold(
//             (l) {
//               emit(OnRegisterErrorState(message: l.message));
//             },
//             (r) async {
//               emit(OnRegisterSuccessState(accountStatus: r.accountStatus));
//             },
//           );
//         })
//         .catchError((error) {
//           emit(OnRegisterCatchErrorState());
//         });
//   }
//
//   Future<void> cashUserData(String token, String name) async {
//     await CacheHelper.setSecuredString(ConstantKeys.saveTokenToShared, token);
//     await CacheHelper.setSecuredString(ConstantKeys.saveNameToShared, name);
//   }
//
//   static RegisterCubit get(context) => BlocProvider.of(context);
// }
