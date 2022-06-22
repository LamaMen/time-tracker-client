import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/data/api/api_service.dart';

@singleton
class ApiProvider {
  final String baseUrl;
  final Dio _dio = Dio();

  ApiProvider(@Named('BaseUrl') this.baseUrl);

  ApiService getService() {
    // _dio.interceptors.add(_logInterceptor);
    return ApiService(_dio, baseUrl: baseUrl);
  }

  // ignore: unused_element
  LogInterceptor get _logInterceptor {
    return LogInterceptor(
      logPrint: (o) => log(o.toString()),
      request: false,
      requestHeader: false,
      responseBody: false,
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