// import 'dart:convert';
//
// import 'package:smart_app/core/api/api_consumer.dart';
// import 'package:smart_app/core/api/status_code.dart';
// import 'package:smart_app/core/exceptions/exceptions.dart';
// import 'package:smart_app/core/exceptions/failure.dart';
// import 'package:smart_app/core/services/cache_helper.dart';
// import 'package:smart_app/core/utils/constant_keys.dart';
// import 'package:smart_app/features/user/sign_in/data/models/register_request_model.dart';
// import 'package:smart_app/features/user/sign_in/data/models/register_response_model.dart';
// import 'package:smart_app/features/user/sign_in/data/services/register_api_end_points.dart';
//
// class RegisterService {
//   ApiConsumer apiConsumer;
//
//   RegisterService({required this.apiConsumer});
//
//   Future<RegisterResponseModel> sign_in(
//       RegisterRequestModel parameter
//   ) async {
//     final response = await apiConsumer.post(
//       RegisterApiEndPoints.registerUrl,
//       RegisterRequestModel(
//         name: parameter.name,
//         email: parameter.email,
//         phone: parameter.phone,
//         countryCode: parameter.countryCode,
//         job: parameter.job,
//         password: parameter.password,
//       ).toJson(),
//       {
//         ConstantKeys.appAuthorization:
//             "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
//       },
//     );
//     print(response.statusCode);
//     print(response.body);
//     if (response.statusCode == StatusCode.ok|| response.statusCode == StatusCode.created) {
//       return RegisterResponseModel.fromJson(jsonDecode(response.body));
//     } else {
//       throw ServerException(
//         serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
//       );
//     }
//   }
// }
