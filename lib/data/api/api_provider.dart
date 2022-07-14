import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/data/api/api_service_admin.dart';
import 'package:time_tracker_client/data/api/api_service_auth.dart';
import 'package:time_tracker_client/data/api/api_service_user.dart';
import 'package:time_tracker_client/data/api/token_interceptor.dart';

@singleton
class ApiProvider {
  final String baseUrl;

  ApiProvider(@Named('BaseUrl') this.baseUrl);

  ApiServiceAuth getAuthService() {
    final dio = Dio();
    // _dio.interceptors.add(_logInterceptor);
    return ApiServiceAuth(dio, baseUrl: '$baseUrl/api/v1/auth');
  }

  ApiServiceUser getUserService() {
    final dio = Dio();
    // dio.interceptors.add(_logInterceptor);
    dio.interceptors.add(getIt<TokenInterceptor>());

    return ApiServiceUser(dio, baseUrl: '$baseUrl/api/v1/user');
  }

  ApiServiceAdmin getAdminService() {
    final dio = Dio();
    // dio.interceptors.add(_logInterceptor);
    dio.interceptors.add(getIt<TokenInterceptor>());

    return ApiServiceAdmin(dio, baseUrl: '$baseUrl/api/v1/admin');
  }

  // ignore: unused_element
  LogInterceptor get _logInterceptor {
    return LogInterceptor(
      logPrint: (o) => log(o.toString()),
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    );
  }
}

@module
abstract class ServerAddressModule {
  @Named('BaseUrl')
  @dev
  String get baseUrlTest => 'https://time-tracker-develop.herokuapp.com';

  @Named('BaseUrl')
  @prod
  String get baseUrlProd => 'https://time-tracker-develop.herokuapp.com';
}
