import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/core/utils/date_utils.dart';
import 'package:time_tracker_client/data/api/api_provider.dart';
import 'package:time_tracker_client/data/models/progress/amendment.dart';
import 'package:time_tracker_client/data/models/progress/progress.dart';

@singleton
class ProgressRepository {
  final ApiProvider _provider;

  ProgressRepository(this._provider);

  Future<Either<Failure, List<Progress>>> fetchGeneral(
    bool isAdmin,
    DateTimeRange? timeRange,
  ) async {
    Map<String, String> params = _convertToParams(timeRange);

    try {
      if (isAdmin) {
        final api = _provider.getAdminService();
        final answer = await api.fetchGeneralProgress(params);
        return Right(answer);
      } else {
        final api = _provider.getUserService();
        final answer = await api.fetchGeneralProgress(params);
        return Right(answer);
      }
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

  Future<Either<Failure, Map<String, List<Progress>>>> fetchProgress(
    String? userId,
    DateTimeRange? timeRange,
  ) async {
    Map<String, String> range = _convertToParams(timeRange);

    try {
      if (userId != null) {
        final api = _provider.getAdminService();
        final answer = await api.fetchProgress(userId, range);
        return Right(answer);
      } else {
        final api = _provider.getUserService();
        final answer = await api.fetchProgress(range);
        return Right(answer);
      }
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

  Map<String, String> _convertToParams(DateTimeRange? timeRange) {
    final range = <String, String>{};
    if (timeRange != null) {
      range['start'] = dateFormatter.format(timeRange.start);
      range['end'] = dateFormatter.format(timeRange.end);
    }
    return range;
  }

  Future<Either<Failure, void>> addAmendment(Amendment amendment) async {
    final api = _provider.getAdminService();
    try {
      await api.addAmendment(amendment);
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
