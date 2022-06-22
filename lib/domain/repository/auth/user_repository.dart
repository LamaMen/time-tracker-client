import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/api/api_provider.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:dartz/dartz.dart';

@singleton
class UserRepository {
  final ApiProvider _provider;

  UserRepository(this._provider);

  Future<Either<Failure, List<User>>> fetchUsers() async {
    final api = _provider.getService();
    try {
      final users = await api.fetchUsers();
      return Right(users);
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