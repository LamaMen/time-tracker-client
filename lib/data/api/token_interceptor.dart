import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/domain/repository/auth/auth_repository.dart';

@injectable
class TokenInterceptor extends Interceptor {
  final AuthRepository _authRepository;

  TokenInterceptor(this._authRepository);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authRepository.getToken();

    if (token != null) {
      options.headers['Authorization'] = token.headerValue;
    }

    handler.next(options);
  }
}
