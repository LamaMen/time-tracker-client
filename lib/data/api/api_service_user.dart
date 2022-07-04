import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:time_tracker_client/data/models/project/project_with_duration.dart';
import 'package:time_tracker_client/data/models/session/session.dart';

part 'api_service_user.g.dart';

@RestApi()
abstract class ApiServiceUser {
  factory ApiServiceUser(Dio dio, {String baseUrl}) = _ApiServiceUser;

  @GET('/api/v1/user/projects')
  Future<List<ProjectWithDuration>> fetchProjects();

  @GET('/api/v1/user/sessions/start/{projectId}')
  Future<void> startSession(@Path('projectId') int projectId);

  @GET('/api/v1/user/sessions/stop/{projectId}')
  Future<void> stopSession(@Path('projectId') int projectId);

  @GET('/api/v1/user/sessions/opened')
  Future<Session> openedSession();
}