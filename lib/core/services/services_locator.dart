import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:get_it/get_it.dart';
import 'package:willizo/features/login_and_signup/data/repo/login_and_signup_repo.dart';
import 'package:willizo/features/login_and_signup/data/services/login_and_signup_service.dart';

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

    ///core

    getIt.registerLazySingleton<AppInterceptor>(() => AppInterceptor());

    getIt.registerLazySingleton<ApiConsumer>(() => HttpConsumer(getIt()));
    getIt.registerLazySingleton(() => http.Client());

    ///shared secure
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    getIt.registerLazySingleton(() => secureStorage);
  }
}
