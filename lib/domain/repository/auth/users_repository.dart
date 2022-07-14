import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/api/api_provider.dart';
import 'package:time_tracker_client/data/models/auth/full_user.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:dartz/dartz.dart';

@singleton
class UsersRepository {
  final ApiProvider _provider;

  UsersRepository(this._provider);

  Future<Either<Failure, List<User>>> fetchUsers() async {
    final api = _provider.getAuthService();
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

  Future<Either<Failure, List<FullUser>>> fetchProtectedUsers() async {
    final api = _provider.getAdminService();
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

  Future<Either<Failure, void>> saveUser(FullUser user) async {
    final api = _provider.getAdminService();
    try {
      if (user.id.isEmpty) {
        await api.addUser(user);
      } else {
        await api.editUser(user);
      }

      return const Right(null);
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
        case HttpStatus.badRequest:
          return const Left(EditYourselfRoleFailure());
      }

      return const Left(UnknownFailure());
    }
  }

  Future<Either<Failure, void>> deleteUser(FullUser user) async {
    final api = _provider.getAdminService();
    try {
      await api.deleteUser(user.id);
      return const Right(null);
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
        case HttpStatus.badRequest:
          return const Left(DeleteYourselfRoleFailure());
      }

      return const Left(UnknownFailure());
    }
  }
}
