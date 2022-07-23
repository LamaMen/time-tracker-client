import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/data/models/project/project_with_duration.dart';

part 'api_service_user.g.dart';

@RestApi()
abstract class ApiServiceUser {
  factory ApiServiceUser(Dio dio, {String baseUrl}) = _ApiServiceUser;

  @GET('/projects')
  Future<List<ProjectWithDuration>> fetchProjects();

  @GET('/statistic/general')
  Future<List<ProjectWithDuration>> fetchGeneralStatistic();

  @GET('/projects/in-work')
  Future<InWorkProject> inWorkProject();

  @GET('/sessions/start/{projectId}')
  Future<void> startSession(@Path('projectId') int projectId);

  @GET('/sessions/stop/{projectId}')
  Future<void> stopSession(@Path('projectId') int projectId);
}
