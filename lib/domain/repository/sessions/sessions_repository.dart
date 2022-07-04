import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/api/api_provider.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/data/models/session/session.dart';

@singleton
class SessionsRepository {
  final ApiProvider _provider;

  SessionsRepository(this._provider);

  Future<Either<Failure, Session?>> getOpenSession() async {
    final api = _provider.getUserService();
    try {
      final session = await api.openedSession();
      return Right(session);
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
        case HttpStatus.notFound:
          return const Right(null);
      }

      return const Left(UnknownFailure());
    }
  }

  Future<Either<Failure, void>> startSession(Project project) async {
    final api = _provider.getUserService();
    try {
      await api.startSession(project.id);
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
      }

      return const Left(UnknownFailure());
    }
  }

  Future<Either<Failure, void>> stopSession(Project project) async {
    final api = _provider.getUserService();
    try {
      await api.stopSession(project.id);
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
      }

      return const Left(UnknownFailure());
    }
  }
}
