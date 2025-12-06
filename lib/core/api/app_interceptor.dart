import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/core/services/cache_helper.dart';

class AppInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers[ConstantKeys.contentType] = ConstantKeys.applicationJson;
    request.headers[ConstantKeys.acceptText] = ConstantKeys.applicationJson;
    
    // Add authorization token if available
    final token = await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared);
    if (token.isNotEmpty) {
      request.headers[ConstantKeys.appAuthorization] = 
          "${ConstantKeys.appBearer} $token";
    }
    
    // request.headers[ConstantKeys.acceptLanguage] =
    //     getIt<AppConstant>().getLanguage();
    debugPrint(request.toString());
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    debugPrint(response.toString());
    return response;
  }
}
