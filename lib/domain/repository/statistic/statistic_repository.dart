import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/api/api_provider.dart';
import 'package:time_tracker_client/data/models/project/project_with_duration.dart';
@singleton
class StatisticRepository {
  final ApiProvider _provider;

  StatisticRepository(this._provider);

  Future<Either<Failure, List<ProjectWithDuration>>> fetchGeneral() async {
    final api = _provider.getUserService();
    try {
      final statistic = await api.fetchGeneralStatistic();
      return Right(statistic);
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
