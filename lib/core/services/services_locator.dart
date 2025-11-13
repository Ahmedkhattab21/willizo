import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:get_it/get_it.dart';
import 'package:willizo/features/complete_account_data/step_18/data/repo/step18_repo.dart';
import 'package:willizo/features/complete_account_data/step_18/data/services/step18_services.dart';
import 'package:willizo/features/complete_account_data/step_19/data/repo/step19_repo.dart';
import 'package:willizo/features/complete_account_data/step_19/data/services/step19_services.dart';
import 'package:willizo/features/complete_account_data/step_20/data/repo/step20_repo.dart';
import 'package:willizo/features/complete_account_data/step_20/data/services/step20_services.dart';
import 'package:willizo/features/login_and_signup/data/repo/login_and_signup_repo.dart';
import 'package:willizo/features/login_and_signup/data/services/login_and_signup_service.dart';
import 'package:willizo/features/forget_password/data/repo/forget_password_repo.dart';
import 'package:willizo/features/forget_password/data/services/forget_password_service.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/data/services/complete_account_service.dart';

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

    getIt.registerLazySingleton<ForgetPasswordRepo>(
      () => ForgetPasswordRepo(getIt()),
    );
    getIt.registerLazySingleton<ForgetPasswordService>(
      () => ForgetPasswordService(apiConsumer: getIt()),
    );

    getIt.registerLazySingleton<CompleteAccountRepo>(
      () => CompleteAccountRepo(completeAccountService: getIt()),
    );
    getIt.registerLazySingleton<CompleteAccountService>(
      () => CompleteAccountService(apiConsumer: getIt()),
    );

    ///core

    getIt.registerLazySingleton<AppInterceptor>(() => AppInterceptor());

    getIt.registerLazySingleton<ApiConsumer>(() => HttpConsumer(getIt()));
    getIt.registerLazySingleton(() => http.Client());

    ///shared secure
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    getIt.registerLazySingleton(() => secureStorage);

    getIt.registerLazySingleton<Step18Services>(() => Step18Services(getIt()));
    getIt.registerLazySingleton<Step18Repo>(() => Step18Repo(getIt()));
    getIt.registerLazySingleton<Step19Services>(() => Step19Services(getIt()));
    getIt.registerLazySingleton<Step19Repo>(() => Step19Repo(getIt()));
    getIt.registerLazySingleton<Step20Services>(() => Step20Services(getIt()));
    getIt.registerLazySingleton<Step20Repo>(() => Step20Repo(getIt()));
  }
}
