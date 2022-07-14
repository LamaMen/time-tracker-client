import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/api/api_provider.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/data/models/project/project_with_duration.dart';

@singleton
class ProjectsRepository {
  final ApiProvider _provider;

  ProjectsRepository(this._provider);

  Future<Either<Failure, List<ProjectWithDuration>>> fetchProjects() async {
    final api = _provider.getUserService();
    try {
      final projects = await api.fetchProjects();
      return Right(projects);
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

  Future<Either<Failure, InWorkProject?>> getInWorkProject() async {
    final api = _provider.getUserService();
    try {
      final project = await api.inWorkProject();
      return Right(project);
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

  Future<Either<Failure, void>> addProject(Project project) async {
    final api = _provider.getAdminService();
    try {
      await api.addProject(project);
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