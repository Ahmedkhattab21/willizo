import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/app_interceptor.dart';
import 'package:willizo/core/api/models/refresh_token_request_model.dart';
import 'package:willizo/core/api/models/refresh_token_response_model.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/api/end_points.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;

class HttpConsumer implements ApiConsumer {
  http.Client _client;
  bool _isRefreshing = false;

  HttpConsumer(this._client) {
    _client = InterceptedClient.build(interceptors: [getIt<AppInterceptor>()]);
  }

  Future<http.Response> _handle401Response(
    http.Response response,
    Future<http.Response> Function() retryFunction,
  ) async {
    if (response.statusCode == StatusCode.unauthorized && !_isRefreshing) {
      debugPrint(
        '🔐 [Token Refresh] 401 Unauthorized detected - Starting automatic token refresh...',
      );
      _isRefreshing = true;
      try {
        debugPrint(
          '🔐 [Token Refresh] Retrieving refresh token from secure storage...',
        );
        final refreshToken = await CacheHelper.getSecuredString(
          ConstantKeys.saveRefreshTokenToShared,
        );

        if (refreshToken.isNotEmpty) {
          debugPrint(
            '🔐 [Token Refresh] Refresh token found, sending refresh request to: ${EndPoints.refreshTokenUrl}',
          );
          debugPrint(
            '🔐 [Token Refresh] Refresh token (first 20 chars): ${refreshToken.length > 20 ? refreshToken.substring(0, 20) + "..." : refreshToken}',
          );

          final plainClient = http.Client();
          final refreshResponse = await plainClient.post(
            Uri.parse(EndPoints.refreshTokenUrl),
            body: json.encode(
              RefreshTokenRequestModel(refreshToken: refreshToken).toJson(),
            ),
            headers: {
              ConstantKeys.contentType: ConstantKeys.applicationJson,
              ConstantKeys.acceptText: ConstantKeys.applicationJson,
            },
          );
          plainClient.close();

          debugPrint(
            '🔐 [Token Refresh] Refresh response status: ${refreshResponse.statusCode}',
          );
          debugPrint(
            '🔐 [Token Refresh] Refresh response body: ${refreshResponse.body}',
          );

          if (refreshResponse.statusCode == StatusCode.ok ||
              refreshResponse.statusCode == StatusCode.created) {
            final refreshData = RefreshTokenResponseModel.fromJson(
              jsonDecode(refreshResponse.body),
            );

            debugPrint('🔐 [Token Refresh] ✅ Token refresh successful!');

            // Save new tokens
            if (refreshData.data?.tokens?.accessToken != null) {
              await CacheHelper.setSecuredString(
                ConstantKeys.saveTokenToShared,
                refreshData.data!.tokens!.accessToken!,
              );
              debugPrint('🔐 [Token Refresh] New access token saved');
            }
            if (refreshData.data?.tokens?.refreshToken != null) {
              await CacheHelper.setSecuredString(
                ConstantKeys.saveRefreshTokenToShared,
                refreshData.data!.tokens!.refreshToken!,
              );
              debugPrint('🔐 [Token Refresh] New refresh token saved');
            }

            debugPrint(
              '🔐 [Token Refresh] Retrying original request with new token...',
            );
            final retryResponse = await retryFunction();
            debugPrint(
              '🔐 [Token Refresh] ✅ Original request retried successfully with status: ${retryResponse.statusCode}',
            );
            return retryResponse;
          } else {
            debugPrint(
              '🔐 [Token Refresh] ❌ Refresh failed with status: ${refreshResponse.statusCode}',
            );
          }
        } else {
          debugPrint('🔐 [Token Refresh] ❌ No refresh token found in storage');
        }
      } catch (e) {
        debugPrint('🔐 [Token Refresh] ❌ Token refresh failed with error: $e');
      } finally {
        _isRefreshing = false;
        debugPrint('🔐 [Token Refresh] Refresh process completed');
      }
    } else if (response.statusCode == StatusCode.unauthorized &&
        _isRefreshing) {
      debugPrint(
        '🔐 [Token Refresh] ⏳ Already refreshing token, skipping duplicate refresh attempt',
      );
    }
    return response;
  }

  @override
  Future<http.Response> get(String path, Map<String, String>? headers) async {
    final response = await _client.get(Uri.parse(path), headers: headers);
    return await _handle401Response(response, () async {
      final token = await CacheHelper.getSecuredString(
        ConstantKeys.saveTokenToShared,
      );
      final updatedHeaders = Map<String, String>.from(headers ?? {});
      if (token.isNotEmpty) {
        updatedHeaders[ConstantKeys.appAuthorization] =
            "${ConstantKeys.appBearer} $token";
      }
      return await _client.get(Uri.parse(path), headers: updatedHeaders);
    });
  }

  @override
  Future<http.Response> put(
    String path,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  ) async {
    final response = await _client.put(
      Uri.parse(path),
      body: json.encode(body),
      headers: headers,
    );
    return await _handle401Response(response, () async {
      final token = await CacheHelper.getSecuredString(
        ConstantKeys.saveTokenToShared,
      );
      final updatedHeaders = Map<String, String>.from(headers ?? {});
      if (token.isNotEmpty) {
        updatedHeaders[ConstantKeys.appAuthorization] =
            "${ConstantKeys.appBearer} $token";
      }
      return await _client.put(
        Uri.parse(path),
        body: json.encode(body),
        headers: updatedHeaders,
      );
    });
  }

  @override
  Future<http.Response> post(
    String path,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  ) async {
    final response = await _client.post(
      Uri.parse(path),
      body: json.encode(body),
      headers: headers,
    );
    return await _handle401Response(response, () async {
      final token = await CacheHelper.getSecuredString(
        ConstantKeys.saveTokenToShared,
      );
      final updatedHeaders = Map<String, String>.from(headers ?? {});
      if (token.isNotEmpty) {
        updatedHeaders[ConstantKeys.appAuthorization] =
            "${ConstantKeys.appBearer} $token";
      }
      return await _client.post(
        Uri.parse(path),
        body: json.encode(body),
        headers: updatedHeaders,
      );
    });
  }

  @override
  Future<http.Response> delete(
    String path,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  ) async {
    final response = await _client.delete(
      Uri.parse(path),
      body: json.encode(body),
      headers: headers,
    );
    return await _handle401Response(response, () async {
      final token = await CacheHelper.getSecuredString(
        ConstantKeys.saveTokenToShared,
      );
      final updatedHeaders = Map<String, String>.from(headers ?? {});
      if (token.isNotEmpty) {
        updatedHeaders[ConstantKeys.appAuthorization] =
            "${ConstantKeys.appBearer} $token";
      }
      return await _client.delete(
        Uri.parse(path),
        body: json.encode(body),
        headers: updatedHeaders,
      );
    });
  }

  @override
  Future<http.Response> multiPost(
    String path,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse(path));
    if (headers != null) {
      request.headers.addAll(headers);
    }

    body.forEach((key, value) async {
      if (key == "images") {
        for (var item in value as List<String>) {
          request.files.add(
            await http.MultipartFile.fromPath(key, item.toString()),
          );
        }
      } else if (key == "captions[]" && value is List<String>) {
        for (var caption in value) {
          request.fields.addAll({"captions[]": caption});
        }
      } else if (key == "remove_images[]") {
        for (var i = 0; i < value.length; i++) {
          request.fields.addAll({"remove_images[$i]": value[i].toString()});
        }
      } else if (key == "files[]") {
        for (var item in value as List<String>) {
          request.files.add(
            await http.MultipartFile.fromPath(key, item.toString()),
          );
        }
      } else if (key == "images[]") {
        for (var item in value as List<String>) {
          request.files.add(
            await http.MultipartFile.fromPath(key, item.toString()),
          );
        }
      } else if (key == "budget_breakdown_file") {
        request.files.add(
          await http.MultipartFile.fromPath(key, value.toString()),
        );
      } else if (key == "img") {
        request.files.add(
          await http.MultipartFile.fromPath(key, value.toString()),
        );
      } else if (key == "logo") {
        request.files.add(
          await http.MultipartFile.fromPath(key, value.toString()),
        );
      } else {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      }
    });
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return response;
  }
}
