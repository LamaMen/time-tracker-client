import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/api/api_provider.dart';
import 'package:time_tracker_client/data/models/auth/token.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/auth/user_credentials.dart';

const String _tokenKey = 'token';

@singleton
class AuthRepository {
  final ApiProvider _provider;
  final SharedPreferences _prefs;

  AuthRepository(this._provider, this._prefs);

  Future<Either<Failure, Token>> login(UserCredentials credentials) async {
    final api = _provider.getAuthService();
    try {
      final token = await api.singIn(credentials);
      await _prefs.setString(_tokenKey, token.token);
      return Right(token);
    } on DioError catch (e) {
      if (e.error is SocketException || e.error.contains('XMLHttpRequest')) {
        return const Left(NoInternetFailure());
      }

      switch (e.response?.statusCode) {
        case HttpStatus.internalServerError:
        case HttpStatus.badGateway:
          return const Left(ServerFailure());
        case HttpStatus.unauthorized:
          return const Left(WrongCredentialsFailure());
      }

      return const Left(UnknownFailure());
    }
  }

  Future<User?> getCurrentUserOrNull() async {
    final token = _prefs.getString(_tokenKey);
    return token != null ? User.fromToken(token) : null;
  }

  Future<User> getCurrentUser() async {
    final token = _prefs.getString(_tokenKey);
    return User.fromToken(token!);
  }

  Future<Token?> getToken() async {
    final token = _prefs.getString(_tokenKey);
    return token != null ? Token(token) : null;
  }

  Future<void> logOut() async {
    _prefs.clear();
  }
}
