import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:willizo/config/routes/routes.dart';
import 'package:willizo/core/api/api_consumer.dart';
import 'package:willizo/core/api/app_interceptor.dart';
import 'package:willizo/core/api/models/refresh_token_request_model.dart';
import 'package:willizo/core/api/models/refresh_token_response_model.dart';
import 'package:willizo/core/api/status_code.dart';
import 'package:willizo/core/api/end_points.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/services/services_locator.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/my_app.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;

class HttpConsumer implements ApiConsumer {
  http.Client _client;
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  static const _authEndpointsWithoutTokenRefresh = [
    '/auth/login',
    '/auth/signup',
    '/auth/refresh',
  ];

  HttpConsumer(this._client) {
    _client = InterceptedClient.build(interceptors: [getIt<AppInterceptor>()]);
  }

  bool _shouldSkipTokenRefresh(String path) {
    return _authEndpointsWithoutTokenRefresh.any(path.contains);
  }

  /// Handles logout when refresh token fails
  Future<void> _handleLogout() async {
    debugPrint('🔐 [Token Refresh] ⚠️ Logging out user due to refresh failure');
    
    // Clear all stored tokens
    await CacheHelper.removeSecureData(ConstantKeys.saveTokenToShared);
    await CacheHelper.removeSecureData(ConstantKeys.saveRefreshTokenToShared);
    await CacheHelper.removeSecureData(ConstantKeys.saveNameToShared);
    
    // Navigate to sign in screen
    final context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.signInScreen,
        (route) => false,
      );
    }
  }

  /// Performs the actual token refresh operation
  Future<bool> _performTokenRefresh() async {
    try {
      debugPrint(
        '🔐 [Token Refresh] Retrieving refresh token from secure storage...',
      );
      final refreshToken = await CacheHelper.getSecuredString(
        ConstantKeys.saveRefreshTokenToShared,
      );

      if (refreshToken.isEmpty) {
        debugPrint('🔐 [Token Refresh] ❌ No refresh token found in storage');
        await _handleLogout();
        return false;
      }

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

        return true;
      } else {
        debugPrint(
          '🔐 [Token Refresh] ❌ Refresh failed with status: ${refreshResponse.statusCode}',
        );
        await _handleLogout();
        return false;
      }
    } catch (e) {
      debugPrint('🔐 [Token Refresh] ❌ Token refresh failed with error: $e');
      await _handleLogout();
      return false;
    }
  }

  /// Handles 401 response with proper queue management for concurrent requests
  Future<http.Response> _handle401Response(
    String path,
    http.Response response,
    Future<http.Response> Function() retryFunction,
  ) async {
    if (response.statusCode != StatusCode.unauthorized) {
      return response;
    }

    if (_shouldSkipTokenRefresh(path)) {
      return response;
    }

    debugPrint(
      '🔐 [Token Refresh] 401 Unauthorized detected - Starting automatic token refresh...',
    );

    // If already refreshing, wait for the ongoing refresh to complete
    if (_isRefreshing && _refreshCompleter != null) {
      debugPrint(
        '🔐 [Token Refresh] ⏳ Already refreshing token, waiting for completion...',
      );
      final refreshSuccess = await _refreshCompleter!.future;
      
      if (refreshSuccess) {
        debugPrint(
          '🔐 [Token Refresh] ✅ Refresh completed by another request, retrying...',
        );
        return await retryFunction();
      } else {
        debugPrint(
          '🔐 [Token Refresh] ❌ Refresh failed, returning original 401 response',
        );
        return response;
      }
    }

    // Start a new refresh operation
    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final refreshSuccess = await _performTokenRefresh();
      _refreshCompleter!.complete(refreshSuccess);

      if (refreshSuccess) {
        debugPrint(
          '🔐 [Token Refresh] Retrying original request with new token...',
        );
        final retryResponse = await retryFunction();
        debugPrint(
          '🔐 [Token Refresh] ✅ Original request retried successfully with status: ${retryResponse.statusCode}',
        );
        return retryResponse;
      }
    } catch (e) {
      _refreshCompleter!.complete(false);
      debugPrint('🔐 [Token Refresh] ❌ Error during refresh: $e');
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
      debugPrint('🔐 [Token Refresh] Refresh process completed');
    }

    return response;
  }

  /// Creates updated headers with fresh token for retry
  Future<Map<String, String>> _getUpdatedHeaders(Map<String, String>? headers) async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    final updatedHeaders = Map<String, String>.from(headers ?? {});
    if (token.isNotEmpty) {
      updatedHeaders[ConstantKeys.appAuthorization] =
          "${ConstantKeys.appBearer} $token";
    }
    return updatedHeaders;
  }

  @override
  Future<http.Response> get(String path, Map<String, String>? headers) async {
    final response = await _client.get(Uri.parse(path), headers: headers);
    return await _handle401Response(path, response, () async {
      final updatedHeaders = await _getUpdatedHeaders(headers);
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
    return await _handle401Response(path, response, () async {
      final updatedHeaders = await _getUpdatedHeaders(headers);
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
    return await _handle401Response(path, response, () async {
      final updatedHeaders = await _getUpdatedHeaders(headers);
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
    return await _handle401Response(path, response, () async {
      final updatedHeaders = await _getUpdatedHeaders(headers);
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
    final response = await _executeMultiPost(path, body, headers);
    
    return await _handle401Response(path, response, () async {
      final updatedHeaders = await _getUpdatedHeaders(headers);
      return await _executeMultiPost(path, body, updatedHeaders);
    });
  }

  /// Executes the multipart POST request
  Future<http.Response> _executeMultiPost(
    String path,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse(path));
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Process body fields and files
    for (var entry in body.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (value == null) continue;

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
      } else if (key == "media") {
        request.files.add(
          await http.MultipartFile.fromPath(key, value.toString()),
        );
      } else {
        request.fields[key] = value.toString();
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return response;
  }
}
