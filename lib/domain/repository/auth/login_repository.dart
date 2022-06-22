import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/api/api_provider.dart';
import 'package:time_tracker_client/data/models/auth/token.dart';
import 'package:time_tracker_client/data/models/auth/user_credentials.dart';

const String _tokenKey = 'token';

@singleton
class LoginRepository {
  final ApiProvider _provider;
  final SharedPreferences _prefs;

  LoginRepository(this._provider, this._prefs);

  Future<Either<Failure, Token>> login(UserCredentials credentials) async {
    final api = _provider.getService();
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
}
