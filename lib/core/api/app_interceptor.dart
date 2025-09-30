 import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:willizo/core/utils/constant_keys.dart';

class AppInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers[ConstantKeys.contentType] = ConstantKeys.applicationJson;
    request.headers[ConstantKeys.acceptText] = ConstantKeys.applicationJson;
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
